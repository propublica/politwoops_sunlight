source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'mysql2'

gem 'httparty', '~> 0.10.0' # used for syncing Twitter avatars
gem 'sitemap_generator', '~> 4.0'

# interacting with Twitter
gem "twitter"
gem "oauth"

gem 'twitter-text' # parsing hashtags and usernames
gem "comma", "~> 3.0"

gem "will_paginate", "~> 3.0.pre2" # pagination
gem "rails_autolink" # auto_link function

#gem "system_timer", "~> 1.2.4"
gem "beanstalk-client"

gem "rmagick", "~> 2.0", require: false
gem "paperclip", "2.7.0"
gem "aws-sdk"

group :assets do
  gem 'sass-rails'
  gem 'uglifier'
end

# allows the app to be run with "bundle exec unicorn" in development
group :development, :test do
  gem 'awesome_print'
  gem 'pry'
  gem 'pry_debug'
  gem 'unicorn'
  gem 'debugger'
  gem "rspec-rails"
end

group :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'vcr'
  gem 'webmock', '1.15.2'
  gem 'capybara'
end

group :production do
  # gem 'memcache'
  gem 'memcache-client'
end
