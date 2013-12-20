require 'spec_helper'



describe "SearchPhrases" do
  
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
   
  describe "GET /search_phrases" do
    
    before :each do
      User.stub(:find_for_facebook_oauth).and_return(@user)
    end

   it "should have the content 'Welcome to Facebook Newsfeed Monitor'" do
      visit '/'
      expect(page).to have_content('Welcome to Facebook Newsfeed Monitor')
    end
  end
end
