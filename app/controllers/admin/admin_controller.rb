class Admin::AdminController < ApplicationController
  layout "admin"

  before_filter :admin_only
  
  protected
  
  def admin_only
    request_url = URI.parse(request.url)
    status_json_path = url_for(:action => 'status',
                               :controller => 'system',
                               :format => 'json',
                               :path_only => true)
    status_json = request_url.path == status_json_path

    ip = request.env['HTTP_X_FORWARDED_FOR'] or request.remote_ip
    from_monitoring_host = configuration[:monitoring_hosts].include? ip
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
