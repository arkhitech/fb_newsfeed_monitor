require 'spec_helper'

describe "search_phrases/index.html.erb" do
  include Devise::TestHelpers
  User.destroy_all
  
  before :all do
    @user = User.find_by_name('testuser')
    @user ||= begin
      user = User.new(email: "test@gmail.com",
        encrypted_password: "$2a$10$TIJrH0tmQ7VuDeBVBIYhJ......................",
        provider: "facebook", uid: "10000697585", name: "testuser",
        fb_token: "AUExuiUkFoBAEsYdxTfU1ONYanI55Sx5ThBTjo7qnKLiZ",
        image: "/asset/images/arkhitech.png")
      user.save!
      user
    end
  end
  
  before  :each do
    User.stub(:find_for_oauth).and_return(@user)
    sign_in @user
  end
  
  before :all do
    @search_phrases = SearchPhrase.find_by_user_id(@user.id)
    @search_phrases ||= begin
      search_phrase= SearchPhrase.new(keyword: "testkeyword",user_id: @user.id) #never hard code
      search_phrase.save!
      search_phrase
    end
  end
    
  let(:search_phrase) do
    mock_model('SearchPhrase',
      :id => 1,
      :keyword => 'testkeyword2',
      :user_id => @user.id,
      :created_at => Time.utc(2000))
  end
  
  before do 
    assign :search_phrases, []
  end
  
  
  #displays and renders the pages
  it "renders the template 'index.html.erb_spec'" do

    puts "*--Search Phrases #{@search_phrases.to_yaml}"
    render
    expect(view).to render_template( "search_phrases/index","search_phrases/_new")
  end
  
  #displays script
  it "displays the script tag '<script>'" do
    render
    expect(rendered).to match /<script>/
  end 

  it "displays the user image in index" do
    render
    expect(rendered).to include(@user.image)
  end  
  
  it "displays the user name in index" do
    #    assign(:user, stub_model(User,
    #      :name => "Asim-Mushtaq"
    #    ))
    render
    expect(rendered).to include(@user.name)
  end

  it "displays the button Text 'Add Keyword'" do
    render
    expect(rendered).to match /Add Keyword/
  end

  it "displays the button 'Add Keyword'" do
    render
    puts "*Rendered View #{rendered}"
    rendered.should have_button('Add Keyword')
  end   

  it "displays the heading'Keyword'" do
    render
    rendered.should have_content('Keyword')
  end  
  
  it "displays the text field 'search_phrase[keyword]'" do
    render
    #    page.find_field('keyword').value || ''
    #    rendered.should have_field('search_phrase[keyword]')
    #    rendered.should have_field(:xpath, "//input[@type=text' and @name='search_phrase[keyword]']")
    #    rendered.should have_selector('input',text=> '',:match=>:first, :visible=> true)
      
  end 
  
  #  it { find_field("search_phrase_keyword").value.blank?.should be_true }
  
  it "displays the button 'Add Keyword'" do
    render
    rendered.should have_button('Add')
  end   
  
  #-------------------------------------------------------------------------------    
  #   it "displays the text field 'search_phrase[keyword]'" do
  #    render
  #    rendered.should have_selector("form", :method => "post", :action => search_phrases_path ) do |f|
  #         f.should have_selector('input',:type => "text",:name=>'search_phrase[keyword]',:id=>'search_phrase_keyword')
  #         f.should have_selector("input", :type => "submit")
  #      end
  #  end 
  

   
  # it "displays the title as an h1" do
  #    render   
  #    rendered.should have_selector 'h4',
  #          :text => 'Keywords',
  #          :count => 1
  #end 
  #-------------------Above test works for css elements--------------------------
end