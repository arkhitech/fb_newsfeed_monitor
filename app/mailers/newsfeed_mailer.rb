class NewsfeedMailer < ActionMailer::Base
  
  default from: "test@arkhitech.com"
  add_template_helper(NewsfeedMailerHelper)
  
  def send_newsfeed(user, feeds)
    @user = user
    @feeds = feeds
    mail(to: @user.email, subject: 'Newsfeed Monitor')
  end
  
end
