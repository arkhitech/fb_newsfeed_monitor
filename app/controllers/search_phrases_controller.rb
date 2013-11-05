require 'mail'

class SearchPhrasesController < ApplicationController
  
  def index
    @keywords = SearchPhrase.all
    
#    keywords = SearchPhrase.all
#    phrases = ''
#    keywords.each do |word|
#      phrases += word.keyword+", "
#    end
#    phrases = phrases[0...phrases.length-2]
#    
#    links='http://www.arkhitech.com , http://www.google.com'
#    
#    Mail.defaults do
#      delivery_method :smtp, { :address   => "smtp.sendgrid.net",
#                               :port      => 587,
#                               :domain    => "http://www.arkhitech.com",
#                               :user_name => "hisham.malik",
#                               :password  => "testing1234",
#                               :authentication => 'plain',
#                               :enable_starttls_auto => true }
#    end
#    mail = Mail.deliver do
#      to 'abuzar.hasan@arkhitech.com'
#      from "Abuzar Hasan <abuzar.hasan@arkhitech.com>"
#      subject 'Related links for Search Phrases'
#      text_part do
#        body ''
#      end
#      html_part do
#        content_type 'text/html; charset=UTF-8'
#        body "<h2> Welcome to Facebook Newsfeed Monitor </h2>

#              <h4> You saved the following Search Phrase(s) </h4>

                  #{phrases}

#              <h4> Following are the link(s) related to above Search Phrase(s) </h4>
              
                  #{links}#"
#      end
#    end
  end
  
  def new
    @keyword = SearchPhrase.new
  end
  
  def create
    @keyword = SearchPhrase.new(params[:search_phrase].permit(:keyword))
    if @keyword.save
#      UserMailer.welcome_email.deliver
      redirect_to search_phrases_path
    else
      render 'new'
    end
  end
  
  def edit
    @keyword = SearchPhrase.find(params[:id])
  end
  
  def update
    @keyword = SearchPhrase.find(params[:id])

    if @keyword.update(params[:search_phrase].permit(:keyword))
      redirect_to search_phrases_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @keyword = SearchPhrase.find(params[:id])
    @keyword.destroy

    redirect_to search_phrases_path
  end
  
end
