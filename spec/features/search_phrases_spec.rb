require 'spec_helper'

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

describe "SearchPhrases" do
  
  def logged_in?
    page.has_selector? "a", text: "Sign Out"
  end

  #===============================================================================

  User.destroy_all
  
  before :all do
    @user = User.find_by_name('testuser')
    @user ||= begin
      user = User.new(email: "test@gmail.com",
        encrypted_password: "$2a$10$TIJrH0tmQ7VuDeBVBIYhJ......................",
        provider: "facebook", uid: "10000697585", name: "testuser",
        fb_token: "AUExuiUkFoBAEsYdxTfU1ONYanI55Sx5ThBTjo7qnKLiZ",
        image: "/assets/arkhitech.png")
      user.save!
      user
    end
  end
  
  before :each do
    User.stub(:find_for_facebook_oauth).and_return(@user)
  end
    
  before :all do
    @search_phrase = SearchPhrase.find_by_user_id(@user.id)
    @search_phrase ||= begin
      search_phrase= SearchPhrase.new(keyword: "testkeyword",user_id: @user.id) #never hard code
      search_phrase.save!
      search_phrase
    end
  end

  #===========TESTS START=========================================================



  describe "Go to Application Start" do
    
    it "should have the content 'Welcome to Facebook Newsfeed Monitor'" do
      visit '/'
      expect(page).to have_content('Welcome to Facebook Newsfeed Monitor')
      expect(page).to have_content('Powered By')
    end
  
  
  end
  
  describe "check images and icons" do

    it "should have the arkhitech logo" do
      visit '/'
      puts "*Facebook  Logo xpath-> #{:xpath.to_s}"
      #      page.should have_xpath("//a/img[src='/assets/arkhitech.png']")
      page.should have_css("img[src*='arkhitech']")
    end
  
 
    it "should have the facebook logo" do
      visit '/'
      puts "*Arkhitech Logo xpath ->#{:xpath}"
      page.should have_css("img[src*='/assets/facebook.ico']")
    end
    
    it "should not be logged in before" do
      visit '/'
      logged_in?.should == false
    end
  
  
  end



  describe "After User Logs In", js: true  do

    before :each do
 
      unless logged_in?
        visit '/'
        OmniAuth.config.mock_auth[:facebook] = {
          provider: 'facebook',
          uid: @user.uid,
          credentials: {
            token: @user.fb_token
          }
        }
        puts "USER_ID: #{User.all.to_yaml}"
        puts "USER_ID: #{@user.id}"
        click_link "Sign in with Facebook" 
      end
    end
  
  
    it "should be logged in" do
      logged_in?.should == true
    end
  
    it "should show the email of user" do
      page.should have_content "Signed in as: #{@user.email}"
    end
  
    it "should show the name of user" do
      page.should have_content "#{@user.name}"
    end
 
    it "should show the display picture of user" do
      page.should have_css("img[src*='#{@user.image}']") 
    end
   
    it "should display add keyword button" do
      page.should have_css("button[class*='btn btn-primary']") 
    end
   
    it "should display keyword testkeyword" do
      page.should have_content "testkeyword"
      page.should have_content "Keywords"
      page.should have_content "Options"
    end
  
    #------------------------------- Now Add Key Word Button Pressed----------------   

    it "click button 'Add Keyword' and display KeyWord heading" do
      #click_button('Add KeyWord') cannot be used due to bootstrap
      find('#toggleKeywordAdd').click 
      expect(page).to have_content('Keyword')
  
    end  
  
    it "click button 'Add Keyword' and display button Add" do
      find('#toggleKeywordAdd').click 
      page.should have_css("input[class*='btn btn-medium btn-primary']") 
    end   
  
    it "click button 'Add Keyword' and display text field" do
      find('#toggleKeywordAdd').click 
      page.should have_css("input[id*='search_phrase_keyword']") 
    end 
  
  
  
    it "click button 'Add Keyword' and add data to the index page" do
      find('#toggleKeywordAdd').click
      puts "#{'*'*80}\n"+page.inspect
      fill_in('search_phrase[keyword]', :with => 'keyword2')
      click_button("Add")
      expect(page).to have_content('keyword2')
    end  
  
    it "click button 'Add Keyword and display edit and remove buttons" do
      find('#toggleKeywordAdd').click
      puts "#{'*'*80}\n"+page.inspect
      fill_in('search_phrase[keyword]', :with => 'KEYWORD_3')
      click_button("Add")
      expect(page).to have_content('KEYWORD_3')
      page.should have_css("button[class*='btn btn-info']")
      page.should have_css("a[class*='btn btn-danger remove_fields']")
    end  
  
  
    it "click button 'Add Keyword', adds keyword and click update button to update" do
      #    find('#toggleKeywordAdd').click
      #    puts "#{'*'*80}\n"+page.inspect
      #    fill_in('search_phrase[keyword]', :with => 'KEYWORD_4')
      #    click_button("Add")
      #    page.should have_css("button[class*='btn btn-info']")

      #CONSIDERING ALREADY ADDED | ELSE GIVES MULTIPLE ERROR
      find(:css,"button[id*='button-edit-#{@search_phrase.id}']" ).click
      page.should have_css("input[class*='btn btn-medium btn-primary']")
      page.should have_css("input[id*='search_phrase_keyword']")
      fill_in('search_phrase[keyword]', :with => 'KEYWORD_EDIT')
      click_button("Update")
      expect(page).to have_content('KEYWORD_EDIT')
    end 
  
    it "click button 'Add Keyword', adds keyword and click delete button to delete" do

      find(:css,"a[href*='/search_phrases/#{@search_phrase.id}']" ).click
      page.driver.browser.switch_to.alert.accept
      page.should have_no_content(@search_phrase.keyword)
    end  
  
  
    it "log out user on Sign Out" do

      click_link("Sign Out")
      current_path.should eq root_path
      logged_in?.should == false
    end 
  
  

  
  end
  
  
end
