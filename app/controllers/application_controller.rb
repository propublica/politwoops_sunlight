class ApplicationController < ActionController::Base
  protect_from_forgery

  helper TweetsHelper
  
  # needs to become more dynamic somehow
  def set_locale
    # not sure what this does
    I18n::Backend::Simple.send(:include, I18n::Backend::Flatten)
    I18n.locale = "en"
  end
  
  def set_twitter
    Twitter.configure do |config|
      config.consumer_key       = 'f8Sgj9idhBH7mPRoYdFbxQ'
      config.consumer_secret    = '11KcMSu13ZIL2UTh8gos9mve5cgWiysFYSqRW4jBQ'
      config.oauth_token        = '260405786-7dd6mKfPdWiXPqczc3k3qYtFrJGHqC8Mo2HyJYp6'
      config.oauth_token_secret = 'mWPfNcKCUSq6i6XVScqWg22OFN8h3PzfK8LxIRL6Y'
    end
    @twitter_client = Twitter::Client.new
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end