class NewsfeedMailer < ActionMailer::Base
  
  default from: "abuzar.hasan@arkhitech.com"
  
  def send_newsfeed(user, feed)
    @user = user
    @feed = feed
#    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Newsfeed Monitor')
  end
  
end
