require 'spec_helper'

class ValidatingWidget < ActiveRecord::Base
  self.table_name = :users
  validates_uniqueness_of :email
end

describe User do
  
  User.destroy_all
  before  :each do
    @user_attr = FactoryGirl.attributes_for(:user)
  end
 
  subject { @user_attr }
 
  describe "Creats a new User" do
    it "should create a new instance of a user given valid attributes" do
      User.create!(@user_attr)
    end
  end

  
  describe "when created again, must give error" do
      
    before {
      @user=User.new(email: "testformodel@gmail.com",
        encrypted_password: "$2a$10$TIJrH0tmQ7VFFFFFFFFFF......................",
        provider: "facebook", uid: "10000000000", name: "testuserduplicate",
        fb_token: "AUExuiUkFoBAEsYdxTfU1ONYanI55Sx5ThBTjo7qnKLiZ")
        @user.save
    }
    
    it {
         expect(ValidatingWidget.new(email: "testformodel@gmail.com")).to have(1).errors_on(:email)
    }
  end
  
end