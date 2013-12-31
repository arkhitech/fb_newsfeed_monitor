
namespace :fb_newsfeed_reminder do
  task :fetch_news => :environment do
    logger = Rails.logger
    
    logger.info 'Starting to fetch_news'
    
    users=User.all
    logger.debug "Users to iterate over: #{users.size}"
    since_time = Time.now - 10.minutes 
    users.each do |user|
      begin
        unless user.search_phrases.empty?
          graph = Koala::Facebook::API.new(user.fb_token)
          feeds = graph.fql_query("SELECT post_id, actor_id, permalink,created_time, message FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me()) AND created_time>'#{since_time.to_i}' ")
          logger.debug "Feed Response for user: #{user.email}: #{user.uid} is:\n#{feeds.inspect}"
          logger.debug "Matching search_phrases: #{user.search_phrases.inspect}"
          
          unique_feeds = feeds.uniq
          logger.debug "Total feeds found: #{feeds.size}, Unique feeds found: #{unique_feeds.size}"
          regular_expressions = []
          
          user.search_phrases.each do |search_phrase|
            regular_expressions << Regexp.escape(search_phrase.keyword)
          end          
          regular_expression = regular_expressions.join('|')

          logger.debug "Regular expression to match: #{regular_expression}"
          unique_feeds.keep_if do |feed|
            /#{regular_expression}/i =~ feed['message'] 
          end
          unless unique_feeds.empty?
            logger.debug "Sending email to user: #{user.email} for matched feeds:\n#{unique_feeds.inspect}"
            NewsfeedMailer.send_newsfeed(user, unique_feeds).deliver
          else
            logger.debug "No match found for regular_express: #{regular_expression} in feeds:\n#{unique_feeds.inspect}"
          end
        else
          logger.debug "No search phrases found for user: #{user.email}"
        end   
      rescue StandardError => e
        puts "Got Exception: #{e.message}\n#{e.backtrace.join("\n")}"
      end
    end
  end
end