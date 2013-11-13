class NewsfeedMailer < ActionMailer::Base
  
  default from: NewsfeedAppConfig[:default][:from_address]
  add_template_helper(NewsfeedMailerHelper)
  
  def send_newsfeed(user, feeds)
    @user = user
    @feeds = feeds
    mail(to: @user.email, subject: 'Newsfeed Monitor')
  end
  
end
