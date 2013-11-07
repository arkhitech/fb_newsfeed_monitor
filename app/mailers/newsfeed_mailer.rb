class NewsfeedMailer < ActionMailer::Base
  
  default from: "info@arkhitech.com"
  
  def send_newsfeed(user, feed)
    @user = user
    @feed = feed
    mail(to: @user.email, subject: 'Newsfeed Monitor')
  end
  
end
