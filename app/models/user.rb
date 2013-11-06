class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :validatable
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable,:omniauthable, 
    :omniauth_providers => [:facebook]
  has_many :search_phrases, dependent: :destroy
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  
    puts "Auth received: #{auth.inspect}"
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
end
