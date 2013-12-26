require 'spec_helper'

describe "layouts/_login_page.html.erb" do
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
    

  
  it "should render to '_login_page'" do
#    expect(rendered).to match /_login_page.html.erb/
    render
    expect(view).to render_template(:partial => "_login_page")
  end
  
  
    it "should have link 'Sign in with Facebook'" do
#    render & rendered are important
    render
    rendered.should have_link('Sign in with Facebook',href: user_omniauth_authorize_path(:facebook))
  end
  
end