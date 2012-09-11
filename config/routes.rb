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

    match "users" => "politicians#admin_list", :as => "admin_list"
    match "user/:id" => "politicians#admin_user", :as => "admin_user"
    match "user/:id/save" => "politicians#save_user", :as => "save_user"
    

    match "offices" => "offices#list", :as => "list_offices"   
    match "offices/add" => "offices#add", :as => "add_office"
    match "offices/save" => "offices#save", :as => "save_office"

    match "review/:rss_secret.rss" => "tweets#index", :reviewed => false, :approved => false, :as => "review_rss", :format => "rss"

    match "review/:id" => "tweets#review", :via => [:post], :as => "review_tweet"
  end
end
