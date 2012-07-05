Politwoops::Application.routes.draw do

  
  namespace :admin do
    match "review" => "tweets#index", :reviewed => false, :approved => false, :as => "review"
    match "unapproved" => "tweets#index", :reviewed => true, :approved => false, :as => "unapproved"
    match "approved" => "tweets#index", :reviewed => true, :approved => true, :as => "approved"
    
    match "review/:rss_secret.rss" => "tweets#index", :reviewed => false, :approved => false, :as => "review_rss", :format => "rss"

    match "review/:id" => "tweets#review", :via => [:post], :as => "review_tweet"
  end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  root :to => "tweets#index"
  
  match "index(.:format)" => "tweets#index", :as => :index
  
  match "statistics/" => "statistics#index"

  match "groups/:id/politicians/add/:politician_id" => "groups_politicians#update"
  
  match "twitter_lists/:user_name/:list" => "twitter_lists#index"
  
  match "politicians/search" => "twitter_users#index"
  
  match "tweet/:id" => "tweets#show", :as => :tweet
  
  match "user/:user_name" => "politicians#show", :as => :politician
  match "user/:user_name/feed/" => "politicians#show", :format => :xml, :as => :politician_feed
  
  match "party/:name" => "parties#show"
  match "party/:name/feed/" => "parties#show", :format => :xml
  
  match "g/:group_name" => "tweets#index"
  match "g/:group_name/feed/" => "tweets#index", :format => :xml
  match "g/:group_name/all/" => "tweets#index", :see => :all
  match "page/:page_slug" => "pages#show"
  
  match "game/typos/" => "typo_game#index"
  match "game/typos/update/:id" => "typo_game#update"
  
  match "countries" => "countries#index"
  
  match "login" => "user_sessions#new"
  match "logout" => "user_sessions#destroy"
  
  match "signup" => "users#new"

  resource :account, :controller => "users"
  resources :users
  resources :politicians
  resources :parties
  resource :user_session
  resources :twitter_lists
  resources :pages
  resources :groups

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end