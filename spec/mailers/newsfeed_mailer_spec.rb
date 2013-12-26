require 'spec_helper'

describe NewsfeedMailer do
  
  describe "testing news feed model" do
    before do
    
      @user=User.new(email: "test@arkhitech.com",
        encrypted_password: "$2a$10$TIJrH0tmQ7VFFFFFFFFFF......................",
        provider: "facebook", uid: "10000000000", name: "testuserduplicate",
        fb_token: "AUExuiUkFoBAEsYdxTfU1ONYanI55Sx5ThBTjo7qnKLiZ")
      @user.save
   
      @user = User.first
      
  
    end
    it "sends an e-mail" do
#       mail(to: @user.email, subject: 'Newsfeed Monitor')
#      ActionMailer::Base.deliveries.last.to.should == [@user.email]
    end
  end
  
end