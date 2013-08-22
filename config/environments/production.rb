Politwoops::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.site_url = "http://2ad.kelmetak.com"

  Twitter.configure do |config|
    config.consumer_key = "QvgsE04ezOWk2RWRnW3xMw"
    config.consumer_secret = "LqnM3b2Y0pfANYvOiGO1PvTDtapZEkVKMMUAoTYzjM"
    config.oauth_token = "1285655682-Gs0RtxzSgUnDi46x54seDld5Bd75kyz4SBoFQrQ"
    config.oauth_token_secret = "rXyA7NPgR4mLz3PXm94gT6y1TNZzUJlKKDSwZZfvuw"
  end


  config.action_mailer.raise_delivery_errors = true

  # set delivery method to :smtp, :sendmail or :test
  #config.action_mailer.delivery_method = :smtp

  configuration ||= YAML.load_file "#{Rails.root}/config/config.yml"

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => configuration[:mailer][:domain],
    :user_name            => configuration[:mailer][:username],
    :password             => configuration[:mailer][:password],
    :authentication       => 'plain',
    :enable_starttls_auto => true  
  }
end