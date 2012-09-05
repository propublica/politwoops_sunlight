Politwoops::Application.routes.draw do

  root :to => "tweets#index"
  
  match "index(.:format)" => "tweets#index", :as => :index
  match "tweet/:id" => "tweets#show", :as => :tweet
  match "user/:user_name" => "politicians#show", :as => :politician
  match "party/:name" => "parties#show", :as => :party

  namespace :admin do
    match "review" => "tweets#index", :reviewed => false, :approved => false, :as => "review"
    match "unapproved" => "tweets#index", :reviewed => true, :approved => false, :as => "unapproved"
    match "approved" => "tweets#index", :reviewed => true, :approved => true, :as => "approved"
    
    match "review/:rss_secret.rss" => "tweets#index", :reviewed => false, :approved => false, :as => "review_rss", :format => "rss"

    match "review/:id" => "tweets#review", :via => [:post], :as => "review_tweet"
  end

  # to remove:

  match "statistics/" => "statistics#index"
  match "twitter_lists/:user_name/:list" => "twitter_lists#index"
  match "politicians/search" => "twitter_users#index"
  match "game/typos/" => "typo_game#index"
  match "game/typos/update/:id" => "typo_game#update"
  
  resources :twitter_lists
end