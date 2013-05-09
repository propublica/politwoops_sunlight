source 'http://rubygems.org'

gem 'rails', '3.2.8'
gem 'mysql2', '0.3.11'

gem 'httparty' # used for syncing Twitter avatars

# interacting with Twitter
gem "twitter"
gem "oauth"

gem "json" # parsing raw Twitter JSON response
gem 'twitter-text' # parsing hashtags and usernames

gem "will_paginate", "~> 3.0.pre2" # pagination
gem "rails_autolink" # auto_link function

gem "system_timer", "~> 1.2.4"

# remove this and switch to built-in CSV class when the app is upgraded to Ruby 1.9
gem "fastercsv"

# allows the app to be run with "bundle exec unicorn" in development
group :development do
  gem 'unicorn'
end

# url shortener
gem "httpi", "~> 2.0.2"
gem "curb"