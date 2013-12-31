require 'spec_helper'

describe UsersController do
  render_views
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
      #     user.confirm!
      user
    end
  end
   
  describe "GET #welcome" do
    
    
    it "responds with success if the controller is invoked" do
      #response.body.should =~ /"welcome"/m
      #       response.body.should eq("welcome")
      response.should be_success
    end
    
    it "renders welcome page and its partial on start of application if not signed in" do
      get :welcome
      expect(response).to render_template("layouts/_login_page", "users/welcome")
    end
    
  end

  describe "REDIRECT #search_phrases If signed in" do  
    # BE CAREFUL | if no new describe then it will take the before to be before all and  give wrong results 
   
    #  Now signing in User  
    before do
      User.stub(:find_for_facebook_oauth).and_return(@user)
      sign_in @user
    end
    
    it "redirects to index template of search phrases if  'Sign In With FaceBook' link pressed " do
      get :welcome
      expect(response).to redirect_to(search_phrases_path)
    end
    
    
  end
end
