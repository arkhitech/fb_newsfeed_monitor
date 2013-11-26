
namespace :fb_newsfeed_reminder do
  task :fetch_news => :environment do
    logger = Rails.logger
    since_time = Time.now - 10.minutes
    logger.info 'Starting to fetch_news'
    
    User.fetch_feeds(since_time)
  end
end