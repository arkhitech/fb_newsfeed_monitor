Newsfeed::Application.routes.draw do
  #devise_for :users
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }  
  root :to => 'users#welcome'

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  get "tweet/tweet_feed" => 'tweet#tweet_feed'
  post "tweet/tweet_search" => 'tweet#tweet_search'
  post '/linkedin/li_search' => 'linkedin#li_search'
  get '/linkedin/li_nw_updates' => 'linkedin#li_nw_updates'
  
#  resources :users
  resources :search_phrases
end
