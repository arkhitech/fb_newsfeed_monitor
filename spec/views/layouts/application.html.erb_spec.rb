require 'spec_helper'

describe "layouts/application.html.erb" do
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
  before  :each do
    User.stub(:find_for_facebook_oauth).and_return(@user)
    sign_in @user
  end
    

  
  it "should render to 'application'" do
    render
    expect(view).to render_template("application")
  end
  
  it "should have title 'NewsFeed'" do
    render
    rendered.should have_title("Newsfeed")
  end
  
  
  it "should have link 'Sign Out'" do
    #    render & rendered are important
    render
    rendered.should have_link('Sign Out',href: destroy_user_session_path)
  end
  
    
  it "should have content'Powered By'" do
    #    render & rendered are important
    render
    rendered.should have_content( "Powered By")
  end  

    
end