module NewsfeedMailerHelper
  def user_search_phrases(user)
    search_phrases = user.search_phrases
    phrases = []
    search_phrases.each do |search_phrase|
      phrases << search_phrase.keyword
    end    
    phrases.join(', ')
  end    
  def highlight_feed(feed, search_phrases)
    highlight(feed['message'], search_phrases.collect{|sp|sp.keyword}, 
               highlighter: '<span style="background-color: #FFFF00">\1</span>')    
  end
end
