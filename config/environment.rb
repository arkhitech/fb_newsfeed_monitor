# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Newsfeed::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => 'hisham.malik',
  :password => 'testing1234',
  :domain => 'yourdomain.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}