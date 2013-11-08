class SearchPhrasesController < ApplicationController
  
  def index
    @keywords = current_user.search_phrases.all
  end
  
  def create
    @keyword = current_user.search_phrases.new(params[:search_phrase].permit(:keyword))
    if @keyword.save
      redirect_to search_phrases_path
    else
      render 'new'
    end
  end
  
  def update
    @keyword = current_user.search_phrases.find(params[:id])

    if @keyword.update(params[:search_phrase].permit(:keyword))
      redirect_to search_phrases_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @keyword = current_user.search_phrases.find(params[:id])
    @keyword.destroy

    redirect_to search_phrases_path
  end
  
end
