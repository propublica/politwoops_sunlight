Politwoops::Application.routes.draw do

  root :to => "tweets#index"

  get "index(.:format)" => "tweets#index", :as => :index
  get "tweet/:id" => "tweets#show", :as => :tweet
  get "tweet/:tweet_id/thumb/:basename.:format" => "tweets#thumbnail"
  get "user/:user_name" => "politicians#show", :as => :politician
  get "users/" => "politicians#all", :as => :all_politicians
  get "party/:name" => "parties#show", :as => :party

  namespace :admin do
    get "status" => "system#status"
    get "restart" => "system#restart"
    get "report" => "system#report"

    get "review" => "tweets#index", :reviewed => false, :approved => false, :as => "review"
    get "unapproved" => "tweets#index", :reviewed => true, :approved => false, :as => "unapproved"
    get "approved" => "tweets#index", :reviewed => true, :approved => true, :as => "approved"

    get "users" => "politicians#admin_list", :as => "admin_list"
    get "user/:id" => "politicians#admin_user", :as => "admin_user"
    post "user/:id/save" => "politicians#save_user", :as => "save_user"
    get "users/new" => "politicians#new_user", :as => "new_user"
    get "users/get-twitter-id/:screen_name" => "politicians#get_twitter_id", :as => "get_twitter_id"

    get "offices" => "offices#list", :as => "list_offices"
    get "offices/add" => "offices#add", :as => "add_office"
    post "offices/save" => "offices#save", :as => "save_office"

    get "offices/:id" => "offices#edit", :as => "edit_office"
    get "review/:rss_secret.rss" => "tweets#index", :reviewed => false, :approved => false, :as => "review_rss", :format => "rss"

    post "review/:id" => "tweets#review", :via => [:post], :as => "review_tweet"

    get "reports/annual/:year" => "reports#annual", :as => "annual_report_year"
    get "reports/annual" => "reports#annual", :as => "annual_report"
    root :to => "tweets#index"
  end

  get "5xx", :to => "errors#down"
  get "404", :to => "errors#not_found"
  get "*anything", :to => "errors#not_found"

end
