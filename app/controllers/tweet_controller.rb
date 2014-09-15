class TweetController < ApplicationController

  def tweet_feed #(user)
      
    consumer = OAuth::Consumer.new("c1vitQ7ff1ENo08EfjaF74zNq", "GdAZ0pxs7chaA4HwGyKYooj7gPaOD312i7XxZtNHTTnVwX7ea2",
      { :site => "https://api.twitter.com",  :scheme => :header } )
      
#    token_hash = {:oauth_token => Identity.find_by_user_id(user.id).access_token,
#      :oauth_token_secret => Identity.find_by_user_id(user.id).access_secret }
    
    token_hash = {:oauth_token => Identity.find_by_user_id(current_user.id).access_token,
      :oauth_token_secret => Identity.find_by_user_id(current_user.id).access_secret }
      
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    
    user_id = current_user.identities.find_by_provider(:twitter).uid
    
    response = access_token.request(:get, "https://api.twitter.com/1.1/statuses/home_timeline.json?count=200", {'Accept-Encoding' => 'identity'})
      
    @tweet = JSON.parse(response.body)
    
    @tweet.each do |friend|
        
      a = Tweet.new
        
      a.tweet_text = friend["text"]
        
      a.tweeter_name = friend["user"]["name"]
        
      a.twitter_user_id = user_id
        
      a.tweet_link = "https://twitter.com/#{friend["user"]["screen_name"]}/status/#{friend["id_str"]}"
        
      if Tweet.where(twitter_user_id: user_id, tweet_link: a.tweet_link).empty?
        a.save!
      end
    end 
  end

  def tweet_search #(user, *Search Phrases*)
        
    twitter_search_word = params[:twitter_search_word] 
      
    @twitter_search_result = []
    @twitter_search_result = Tweet.search twitter_search_word, :conditions => {:twitter_user_id => current_user.identities.find_by_provider(:twitter).uid }
#    NewsfeedMailer.send_newsfeed(user, @twitter_search_result)
  end
   
end