class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :validatable
  # :lockable, :timeoutable and :omniauthable
  
  has_many :tweets
  has_many :linkedins
  has_many :identities
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :twitter, :linkedin]
  
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  has_many :search_phrases, dependent: :destroy
  
  
  
  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity && identity.user
    
    user = User.find_by_email(auth.info.email) unless user
    
    # Create the user if needed
    if user.nil?
      
      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email ? auth.info.email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
      
      user = User.where(:email => email).first
      if user && email_is_verified
        user.skip_confirmation!
      elsif user
        #user is present, but email is not verified
        #don't skip confirmation ourselves
      elsif email_is_verified
        #user is nil and email is verified
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email,
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      else
        #user is nil and email is not verified
        #create user and skip confirmation
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email,
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end
    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end
  def self.fetch_feeds(time)
    users=self.all
#    logger.debug "Users to iterate over: #{users.size}"
    since_time = time 
    users.each do |user|
#       if user.provider == 'facebook'
          user.match_feeds(since_time)
          #       elseif   Identity.find_by_user_id(user.id).provider == 'twitter'
#         Tweet.tweet_feed(user)
#         (Tweet).tweet_search(user, *Search Phrases*) 
          #       elseif   Identity.find_by_user_id(user.id).provider == 'linkedin'
#         Linkedin.li_nw_updates(user)
#         (Linkedin).li_search(user, *Search Phrases*) 
#       end
    end
  end
  def match_feeds(since)
    since_time = since
    unless self.search_phrases.empty?
      graph = Koala::Facebook::API.new(self.fb_token)
      feeds = graph.fql_query("SELECT post_id, actor_id, permalink,created_time, message FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me()) AND created_time>'#{since_time.to_i}' ")
#      logger.debug "Feed Response for self: #{self.email}: #{self.uid} is:\n#{feeds.inspect}"
#      logger.debug "Matching search_phrases: #{self.search_phrases.inspect}"
          
      unique_feeds = feeds.uniq
#      logger.debug "Total feeds found: #{feeds.size}, Unique feeds found: #{unique_feeds.size}"
      regular_expressions = []
          
      self.search_phrases.each do |search_phrase|
        regular_expressions << Regexp.escape(search_phrase.keyword)
      end          
      regular_expression = regular_expressions.join('|')

#      logger.debug "Regular expression to match: #{regular_expression}"
      unique_feeds.keep_if do |feed|
        /#{regular_expression}/i =~ feed['message'] 
      end
      unless unique_feeds.empty?
#        logger.debug "Sending email to self: #{self.email} for matched feeds:\n#{unique_feeds.inspect}"
        NewsfeedMailer.send_newsfeed(self, unique_feeds).deliver
      else
#        logger.debug "No match found for regular_express: #{regular_expression} in feeds:\n#{unique_feeds.inspect}"
      end
    else
#      logger.debug "No search phrases found for self: #{self.email}"
    end   
  rescue StandardError => e
#    puts "Got Exception: #{e.message}\n#{e.backtrace.join("\n")}"
  end
  
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user| 
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]   
    end
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
    def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
  
end
  
 
