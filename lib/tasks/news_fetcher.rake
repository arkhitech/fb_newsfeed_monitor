namespace :fb_newsfeed_reminder do
  task :fetch_news => :environment do
   users=User.all
   since_time = Time.now - 10.minutes 
   users.each do |user|
     begin
     graph = Koala::Facebook::API.new(user.fb_token)
     feed = graph.fql_query("SELECT post_id, actor_id, permalink,created_time, message FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me()) AND created_time>'#{since_time.to_i}' ")
     feed.uniq!
     regular_expression = ''
     user.search_phrases.each do |search_phrase|
       regular_expression << search_phrase.keyword+'|'
     end
     regular_expression = regular_expression[0...regular_expression.length-1]
        unless regular_expression.length<4
          feed.keep_if{|post| post['message']=~ /#{regular_expression}/i }
          #mail people user.email
        end   
    rescue StandardError => e
      puts "Got Exception: #{e.message}\n#{e.backtrace.join("\n")}"
    end
   end
  end
end