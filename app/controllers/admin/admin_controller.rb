class Admin::AdminController < ApplicationController
  layout "admin"

  before_filter :admin_only
  
  protected
  
  def admin_only
    unless params[:format] == "rss"
      authenticate_or_request_with_http_basic do |username, password|
        username == config[:admin][:username] and password == config[:admin][:password]
      end
    end
  end

  helper_method :latest_tweet
  def latest_tweet
    @latest_tweet ||= Tweet.first
  end

  helper_method :latest_deleted_tweet
  def latest_deleted_tweet
    @latest_deleted_tweet ||= DeletedTweet.first
  end

  def config
    @config ||= YAML.load_file "#{Rails.root}/config/config.yml"
  end

  helper_method :current_admin_rss
  def current_admin_rss
    "#{request.url}/#{credentials[:rss_secret]}.rss"
  end
end