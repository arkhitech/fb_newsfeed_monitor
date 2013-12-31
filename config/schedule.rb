set :environment, "developmenet"

every 30.minutes do  
  rake 'fb_newsfeed_reminder:fetch_news'
end