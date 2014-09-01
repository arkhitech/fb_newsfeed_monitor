class SearchPhrasesController < ApplicationController
  
  def index
    @search_phrases = current_user.search_phrases.all
  end
  
  def create       
    @search_phrase = current_user.search_phrases.new(params[:search_phrase].permit(:keyword))
    #    @search_phrase = current_user.search_phrases.new(params[:keyword]) #Changed by Me
    
    respond_to do |format|
      if @search_phrase.save
        format.html { redirect_to search_phrases_path, notice: 'Search Phrase was successfully created.' }
        format.js   {}
      else
        format.html { redirect_to search_phrases_path, notice: 'ERROR!' }
      end
    end
    #    @search_phrase = current_user.search_phrases.new(params[:search_phrase].permit(:keyword))
    #    if @search_phrase.save
    #      redirect_to search_phrases_path
    #    else
    #      redirect_to search_phrases_path
    #    end
  end
  
  def update
    @search_phrase = current_user.search_phrases.find(params[:id])
    
    respond_to do |format|
      if @search_phrase.update(params[:search_phrase].permit(:keyword))
        format.html { redirect_to search_phrases_path, notice: 'Search Phrase was successfully updated.' }
        format.js {}
      else
        format.html { redirect_to search_phrases_path, notice: 'ERROR!' }
      end
    end
  end
  
  def destroy
    @search_phrase = current_user.search_phrases.find(params[:id])
    @search_phrase.destroy
    respond_to do |format|
#      if @search_phrase.destroy
        format.html { redirect_to search_phrases_path, notice: 'Search Phrase was successfully deleted.' }
        format.js {}
#      end
    end
#    redirect_to search_phrases_path
  end
  
end
