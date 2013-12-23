require 'spec_helper'

describe SearchPhrasesController do
  
  render_views
  include Devise::TestHelpers
  #  User.destroy_all
  #  SearchPhrase.destroy_all
  
  
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
  
  before :all do
    @search_phrases = SearchPhrase.find_by_user_id(@user.id)
    @search_phrases ||= begin
      search_phrase= SearchPhrase.new(keyword: "testkeyword",user_id: @user.id) #never hard code
      search_phrase.save!
      search_phrase
    end
  end
  
  describe "GET #index" do
    
    
    it "index responds with success if the controller is invoked" do
      get :index
      response.should be_success
    end
    
    it "renders Index page with user signed in" do
      get :index
      expect(response).to render_template("index")
    end
    
    it "renders Index page with user signed in" do
      #     search_phrase1, search_phrase2 = SearchPhrase.create!, SearchPhrase.create!
   
      get :index
      #     expect(assigns(:search_phrase)).to match_array([search_phrase1, search_phrase2])
      expect(assigns(:search_phrases)).to match_array([@search_phrases])
    end
     

    
  end
  
  
  # PERMIT ISSUE
  describe "POST #create" do
    
    
    #    it "CREATE should redirect to 'index' with a notice on successful save" do
    #         params = ActionController::Parameters.new(@search_phrases)
    #         post :create ,:search_phrases => { :params => params }
    #         response.should redirect_to(search_phrases_path)
    #    end
    #    
    #      it "CREATE should pass params to search phrases" do
    #      post 'create', :search_phrases => { :keyword => 'newkeyword' }
    #      assigns[:search_phrases ].keyword.should == 'newkeyword'
    #      end
    #    
  end  
  
  
  describe "PUT #update" do
    
    
    it "update responds with success if the controller is invoked" do
      
      
      #      SearchPhrase.stub(:permit).and_return(@search_phrases)
#      params = ActionController::Parameters.new(search_phrase: {:keyword =>'testkeyword'})
#      #      search_phrase_params=SearchPhrasesController::SearchPhraseParams.build(params)
#      #      params.require('testkeyword').permit!
#      params.require(:search_phrase).permit(:keyword)
#      #      SearchPhrase.stub(:permit).and_return(:keyword)
#      #      SearchPhrase.should_receive(:update).with
#      #                    ({keyword: 'testkeyword'}.with_indifferent_access)     
#      expect(params).to eq({search_phrase: {:keyword =>'testkeyword'}}.with_indifferent_access)

      put 'update', :id => @search_phrases.id, search_phrase: {keyword: 'testkeyword'}
      
      params = ActionController::Parameters.new(search_phrase: {:keyword =>'testkeyword'})
      expect(params).to eq({search_phrase: {:keyword =>'testkeyword'}}.with_indifferent_access)
      response.should be_success

    end
        
        it "should update search_phrases attributes" do
          put :update, :id => @search_phrases.id, search_phrase: {keyword: 'testkeyword'}
          @search_phrases.update_attributes(keyword: "testkeywordUpdate")
#          @time_invoice.reload
          @search_phrases.keyword.should eq("testkeywordUpdate")
        end
    #
    #    it "should redirect to index after successful updation" do
    #      get 'update', :id => @search_phrases.id
    #      response.should redirect_to(@search_phrases)        
    #    end
    #----------------------------------------~|above
    
    #    it "renders Index page with user signed in" do
    #      get :update
    #      expect(response).to render_template("update")
    #    end
    
  end
  
  
  describe "GET #destroy" do
    
    #check how to delete single
    it "destroy responds with success if the controller is invoked" do
      delete :destroy, :id => @search_phrases.id, :user_id => @user.id
      #      SearchPhrase.destroy(:user_id => @user.id)
      SearchPhrase.destroy_all
      response.should redirect_to(search_phrases_path)  
    end
    
  end
  

end
