Newsfeed::Application.routes.draw do
  #devise_for :users
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" },:skip=>[:sessions]
  
  
devise_scope :user do
  get 'sign_in', :to => 'users#welcome', :as => :new_user_session
  delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
end
  
  root :to => 'users#welcome'
  resources :users
  resources :search_phrases
end
