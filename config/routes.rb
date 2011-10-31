Politwoops::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  root :to => "tweets#index"
  
  match "index(.:format)" => "tweets#index"
  
  match "feed/" => "tweets#index", :format => :xml
  
  match "statistics/" => "statistics#index"
  
  # See how all your routes lay out with "rake routes"

  match "groups/:id/politicians/add/:politician_id" => "groups_politicians#update"
  
  match "twitter_lists/:user_name/:list" => "twitter_lists#index"
  
  match "politicians/search" => "twitter_users#index"
  
  match "tweet/:id" => "tweets#show"
  
  match "user/:user_name" => "politicians#show"
  match "user/:user_name/feed/" => "politicians#show", :format => :xml
  
  match "party/:name" => "parties#show"
  match "party/:name/feed/" => "parties#show", :format => :xml
  
  match "g/:group_name" => "tweets#index"
  match "g/:group_name/feed/" => "tweets#index", :format => :xml
  match "g/:group_name/all/" => "tweets#index", :see => :all
  match "page/:page_slug" => "pages#show"
  
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