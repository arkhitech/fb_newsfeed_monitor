class LinkedinController < ApplicationController

  def li_nw_updates
        
    consumer = OAuth::Consumer.new('75o5g5mptd8gnn', 'z4T3bI2jfVilsTOO')
    
    linkedin_identity = current_user.identities.find_by_provider(:linkedin)
    
    success_token = OAuth::AccessToken.new(consumer, linkedin_identity.access_token, linkedin_identity.access_secret)
          
    type_SHAR = success_token.get("https://api.linkedin.com/v1/people/~/network/updates:(update-content:(person:(first-name,last-name,headline,current-share:(comment,content:(description,title,shortened-url)))))?type=SHAR", 'x-li-format' => 'json').body
    @update_SHAR = JSON.parse(type_SHAR)

    if (@update_SHAR["values"].length > 0)
      for i in 0..((@update_SHAR["values"].length)-1)
      
        if  @update_SHAR["values"][i]["updateContent"]["person"]["currentShare"]["content"]
        
          a = Linkedin.new
        
          a.li_user_id = linkedin_identity.uid
        
          a.li_updater_first_name = @update_SHAR["values"][i]["updateContent"]["person"]["firstName"]
        
          a.li_updater_last_name = @update_SHAR["values"][i]["updateContent"]["person"]["lastName"]
        
          a.li_updater_headline = @update_SHAR["values"][i]["updateContent"]["person"]["headline"]
        
          a.li_update_title = @update_SHAR["values"][i]["updateContent"]["person"]["currentShare"]["content"]["title"]
        
          a.li_update_shortened_url = @update_SHAR["values"][i]["updateContent"]["person"]["currentShare"]["content"]["shortenedUrl"]
        
          if Linkedin.where(li_user_id: linkedin_identity.uid, li_update_shortened_url: a.li_update_shortened_url).empty?
            a.save!
          end
        end 
      end
    end
  end
    
  def li_search
        
    user_id = current_user.identities.find_by_provider(:linkedin).uid
    li_search_word = params[:li_search_word] 
      
    @li_search_result = []
    @li_search_result = Linkedin.search li_search_word, :conditions => {:li_user_id => user_id }
#    NewsfeedMailer.send_newsfeed(user, @li_search_result)
  end
  
end
