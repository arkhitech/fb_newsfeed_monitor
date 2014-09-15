ThinkingSphinx::Index.define :tweet, :with => :real_time do
  
  indexes tweet_text
  indexes twitter_user_id 
  
end