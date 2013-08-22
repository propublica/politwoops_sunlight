Politwoops::Application.routes.draw do
  
  root :to => "tweets#index"
  
  match "index(.:format)" => "tweets#index", :as => :index
  match "tweet/:id" => "tweets#show", :as => :tweet
  match "user/:user_name" => "politicians#show", :as => :politician
  match "users/" => "politicians#all", :as => :all_politicians
  match "users/list" => "politicians#index", :as => :all_politicians
  match "users/suggest" => "politicians#suggest", :as => :suggest
  match "users/send_suggestion" => "politicians#send_suggestion", :as => :send_suggestion
  match "users/get-twitter-id/:screen_name" => "politicians#get_twitter_id", :as => "get_twitter_id"
  match "party/:name" => "parties#show", :as => :party
  match "tweets/shorten_url" => "tweets#shorten_url"

  namespace :admin do
    root :to => "tweets#index", :reviewed => false, :approved => false, :as => "review"
    resources :administrators, :sys_settings
    match "status" => "system#status"
    match "restart" => "system#restart"
    match "start" => "system#start"
    match "report" => "system#report"

    match "review" => "tweets#index", :reviewed => false, :approved => false, :as => "review"
    match "unapproved" => "tweets#index", :reviewed => true, :approved => false, :as => "unapproved"
    match "approved" => "tweets#index", :reviewed => true, :approved => true, :as => "approved"
    match "reject" => "tweets#reject", :as => "reject"
    match "approve" => "tweets#approve", :as => "approve"
    match "tweets/:id/next_tweets" => "tweets#next_tweets", :as => "next_tweets"

    match "users" => "politicians#admin_list", :as => "admin_list"
    match "user/:id" => "politicians#admin_user", :as => "admin_user"
    match "user/:id/save" => "politicians#save_user", :as => "save_user"
    match "users/new" => "politicians#new_user", :as => "new_user"
    match "users/get-twitter-id/:screen_name" => "politicians#get_twitter_id", :as => "get_twitter_id"
    match "user/:id/disable" => "politicians#disable", :as => "disable"
    match "users/update" => "politicians#update", :as => "politicians_update", :via => [:post]
    
    match "parties" => "parties#list", :as => "list_parties"   
    match "parties/add" => "parties#add", :as => "add_party"
    match "parties/save" => "parties#save", :as => "save_party"
    match "parties/:id" => "parties#edit", :as => "edit_party"

    match "offices" => "offices#list", :as => "list_offices"   
    match "offices/add" => "offices#add", :as => "add_office"
    match "offices/save" => "offices#save", :as => "save_office"

    match "offices/:id" => "offices#edit", :as => "edit_office"
    match "review/:rss_secret.rss" => "tweets#index", :reviewed => false, :approved => false, :as => "review_rss", :format => "rss"

    match "review/:id" => "tweets#review", :via => [:post], :as => "review_tweet"
  end
  
  
  match "about", :to=> "static#about"
  match "404", :to => "errors#not_found"    
  match "*anything", :to => "errors#not_found"

end
