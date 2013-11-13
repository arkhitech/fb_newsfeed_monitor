
namespace :fb_newsfeed_reminder do
  task :fetch_news => :environment do
    logger = Rails.logger
    
    logger.info 'Starting to fetch_news'
    
    User.fetch_feeds
  end
end