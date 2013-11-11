Newsfeed::Application.routes.draw do
  #devise_for :users
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }  
  root :to => 'users#welcome'
  resources :users
  resources :search_phrases
end
