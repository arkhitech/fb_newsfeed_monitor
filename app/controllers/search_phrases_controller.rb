class SearchPhrasesController < ApplicationController
  
  def index
    @keywords = current_user.search_phrases.all
  end
  
  def new
    @keyword = SearchPhrase.new
  end
  
  def create
    @keyword = current_user.search_phrases.new(params[:search_phrase].permit(:keyword))
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
