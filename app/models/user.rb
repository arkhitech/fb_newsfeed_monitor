class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :validatable
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable,:omniauthable, 
    :omniauth_providers => [:facebook]
  has_many :search_phrases, dependent: :destroy
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    logger_db = Rails.logger
    logger_db.info "Auth received: #{auth.inspect}"
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create!(name:auth.extra.raw_info.name,
        provider:auth.provider,
        uid:auth.uid,
        email:auth.info.email,
        password:Devise.friendly_token[0,20],
        fb_token:auth.credentials.token,
        image:auth.info.image
      )
    else
      user.fb_token = auth.credentials.token
      user.save!
    end
    user
  end
  def self.fetch_feeds
    users=self.all
    logger.debug "Users to iterate over: #{users.size}"
    since_time = Time.now - 10.minutes 
    users.each do |user|
      user.match_feeds(since_time)
    end
  end
  def match_feeds(since)
    since_time = since
    unless self.search_phrases.empty?
      graph = Koala::Facebook::API.new(self.fb_token)
      feeds = graph.fql_query("SELECT post_id, actor_id, permalink,created_time, message FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me()) AND created_time>'#{since_time.to_i}' ")
      logger.debug "Feed Response for self: #{self.email}: #{self.uid} is:\n#{feeds.inspect}"
      logger.debug "Matching search_phrases: #{self.search_phrases.inspect}"
          
      unique_feeds = feeds.uniq
      logger.debug "Total feeds found: #{feeds.size}, Unique feeds found: #{unique_feeds.size}"
      regular_expressions = []
          
      self.search_phrases.each do |search_phrase|
        regular_expressions << Regexp.escape(search_phrase.keyword)
      end          
      regular_expression = regular_expressions.join('|')

      logger.debug "Regular expression to match: #{regular_expression}"
      unique_feeds.keep_if do |feed|
        /#{regular_expression}/i =~ feed['message'] 
      end
      unless unique_feeds.empty?
        logger.debug "Sending email to self: #{self.email} for matched feeds:\n#{unique_feeds.inspect}"
        NewsfeedMailer.send_newsfeed(self, unique_feeds).deliver
      else
        logger.debug "No match found for regular_express: #{regular_expression} in feeds:\n#{unique_feeds.inspect}"
      end
    else
      logger.debug "No search phrases found for self: #{self.email}"
    end   
  rescue StandardError => e
    puts "Got Exception: #{e.message}\n#{e.backtrace.join("\n")}"
  end
end
