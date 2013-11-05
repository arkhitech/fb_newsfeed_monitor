# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Newsfeed::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => 'hisham.mailk',
  :password => 'testing1234',
  :domain => 'arkhitech.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}