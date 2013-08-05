Politwoops::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.site_url = "http://beta.2ad.kelmetak.com"
  

  Twitter.configure do |config|
    config.consumer_key = "QvgsE04ezOWk2RWRnW3xMw"
    config.consumer_secret = "LqnM3b2Y0pfANYvOiGO1PvTDtapZEkVKMMUAoTYzjM"
    config.oauth_token = "1285655682-Gs0RtxzSgUnDi46x54seDld5Bd75kyz4SBoFQrQ"
    config.oauth_token_secret = "rXyA7NPgR4mLz3PXm94gT6y1TNZzUJlKKDSwZZfvuw"
  end

  config.action_mailer.raise_delivery_errors = true

  # set delivery method to :smtp, :sendmail or :test
  #config.action_mailer.delivery_method = :smtp
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => '2ad.kelmetak.com',
    :user_name            => '2ad.kelmetak@gmail.com',
    :password             => 'a@D.K3lM3t@K',
    :authentication       => 'plain',
    :enable_starttls_auto => true  
  }
end