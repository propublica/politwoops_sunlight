class Admin::AdminController < ApplicationController
  layout "admin"

  before_filter :admin_only
  
  protected
  
  def admin_only
    status_json = request.url == url_for(:action => 'status',
                                         :controller => 'system',
                                         :format => 'json')
    from_monitoring_host = configuration[:monitoring_hosts].include? request.remote_ip
    monitoring_request = (status_json and from_monitoring_host)

    unless (params[:format] == "rss" or monitoring_request)
      authenticate_or_request_with_http_basic do |username, password|
        username == configuration[:admin][:username] and password == configuration[:admin][:password]
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

  def configuration
    @configuration ||= YAML.load_file "#{Rails.root}/config/config.yml"
  end

  helper_method :current_admin_rss
  def current_admin_rss
    "#{request.url}/#{configuration[:rss_secret]}.rss"
  end
end
