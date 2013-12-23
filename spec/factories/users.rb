# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do 
  factory :user do |user|
    
    user.email "testformodel@gmail.com"
    user.encrypted_password "$2a$10$TIJrH0tmQ7VuDeBVBIYhJ......................"
    user.provider "facebook"
    user.uid "10000697585"
    user.name "testuserformodel"
    user.fb_token "AUExuiUkFoBAEsYdxTfU1ONYanI55Sx5ThBTjo7qnKLiZ"
  end
end
