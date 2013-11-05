class UsersController < ApplicationController
  def welcome
    if user_signed_in?
      redirect_to search_phrases_path
    end
  end
end
