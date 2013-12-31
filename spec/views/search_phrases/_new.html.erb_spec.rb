require 'spec_helper'

describe "search_phrases/_new.html.erb" do
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

  before(:each) do
    @search_phrase = assign(:search_phrase, stub_model(SearchPhrase)).as_new_record.as_null_object
     puts "*__ #{@search_phrase.to_yaml}"
  end
  
  it "renders the partial views '_new.html.erb_spec'" do
    
  
     render
     expect(view).to render_template("search_phrases/_error", "search_phrases/_new")
  
  end
  
  it "renders the form partial '_new.html.erb_spec'" do
    puts "*___ #{rendered}"
    
    render
    rendered.should have_selector('form') do |form|
      form.should have_selector('input',:type => "text",:name=>'search_phrase[keyword]',:id=>'search_phrase_keyword')
      form.should have_selector('input',:type=>'submit',:value=>'Add')
    end
  end
  
end