require 'spec_helper'

class ValidatingWidget < ActiveRecord::Base
  self.table_name = :user
  validates_duplication_of :uid
end

describe User do

  #  User.destroy_all
  #  before :all do
  #    @user = User.find_by_name('testuser')
  #    @user ||= begin
  #      user = User.new(email: "test@gmail.com",
  #        encrypted_password: "$2a$10$TIJrH0tmQ7VuDeBVBIYhJ......................",
  #        provider: "facebook", uid: "10000697585", name: "testuser",
  #        fb_token: "AUExuiUkFoBAEsYdxTfU1ONYanI55Sx5ThBTjo7qnKLiZ")
  #      user.save!
  #      user
  #    end
  #  end
  
  #  User.destroy_all
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
    it "should give error if duplicate created" do
      User.create(@user_attr)
    end
  end

  
end