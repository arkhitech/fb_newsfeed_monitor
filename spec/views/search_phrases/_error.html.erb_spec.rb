require 'spec_helper'

describe "search_phrases/_error.html.erb" do
  include Devise::TestHelpers
  User.destroy_all
  
    before :all do
    @user = User.find_by_name('testuser')
    @user ||= begin
      user = User.new(email: "test@gmail.com",
        encrypted_password: "$2a$10$TIJrH0tmQ7VuDeBVBIYhJ......................",
        provider: "facebook", uid: "10000697585", name: "testuser",
        fb_token: "AUExuiUkFoBAEsYdxTfU1ONYanI55Sx5ThBTjo7qnKLiZ")
      user.save!
      user
    end
  end
  
  before  :each do
    User.stub(:find_for_facebook_oauth).and_return(@user)
    sign_in @user
  end
  
  before :all do
    @search_phrase = SearchPhrase.find_by_user_id(@user.id)
    @search_phrase ||= begin
      search_phrase= SearchPhrase.new(keyword: "testkeyword",user_id: @user.id) #never hard code
      search_phrase.save!
      search_phrase
    end
  end

   it "creates render error partial page" do
       view.stub(:render).with(hash_including(:partial => "search_phrases/error"))
    end
  
end