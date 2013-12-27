require 'spec_helper'

describe "search_phrases/_index.html.erb" do
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

  before(:each) do
    @search_phrase_new = assign(:search_phrase, stub_model(SearchPhrase)).as_new_record.as_null_object
  end
  
  it "renders the template '_index.html.erb_spec' with errors" do
    
    puts "*--Old> #{@search_phrase.to_yaml}"
    puts "*--New> #{@search_phrase_new.to_yaml}"
    render
    expect(view).to render_template("search_phrases/_error", "search_phrases/_index")
  end
    
    
  it "renders the partial form '_index.html.erb_spec'" do
    render
    puts "*--> #{rendered}"
    rendered.should have_selector('form') do |form|
      form.should have_selector('input',:type => "text",:name=>'search_phrase[keyword]',:id=>'search_phrase_keyword')
      form.should have_selector('input',:type=>'submit',:value=>'Update')
    end
  end
  
end