
namespace :fb_newsfeed_reminder do
  task :fetch_news => :environment do
    users=User.all
    since_time = Time.now - 10.minutes 
    users.each do |user|
      begin
        graph = Koala::Facebook::API.new(user.fb_token)
        feeds = graph.fql_query("SELECT post_id, actor_id, permalink,created_time, message FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me()) AND created_time>'#{since_time.to_i}' ")
        feeds = feeds.uniq
        regular_expressions = []
        unless user.search_phrases.empty?
          user.search_phrases.each do |search_phrase|
            regular_expressions << Regexp.escape(search_phrase.keyword)
          end
          
          regular_expression = regular_expressions.join('|')
          feeds.keep_if do |feed|
            /#{regular_expression}/i =~ feed['message'] 
          end
          unless feeds.empty?
            NewsfeedMailer.send_newsfeed(user, feeds).deliver
          end
        end   
      rescue StandardError => e
        puts "Got Exception: #{e.message}\n#{e.backtrace.join("\n")}"
      end
    end
  end
end