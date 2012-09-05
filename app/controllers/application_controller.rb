class ApplicationController < ActionController::Base
  protect_from_forgery

  # let tweet helper methods be available in the controller
  helper TweetsHelper
  
  # needs to become more dynamic somehow
  def set_locale
    # not sure what this does
    I18n::Backend::Simple.send(:include, I18n::Backend::Flatten)
    I18n.locale = "en"
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end