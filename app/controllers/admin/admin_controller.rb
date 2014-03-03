class Admin::AdminController < ApplicationController
  layout "admin"

  before_filter :admin_only

  protected
  
  def admin_only
    request_url = URI.parse(request.url)
    status_json_path = url_for(:action => 'status',
                               :controller => 'system',
                               :format => 'json',
                               :only_path => true)
    status_json = request_url.path == status_json_path

    ips = (request.env['HTTP_X_FORWARDED_FOR'] or request.remote_ip).split(',')
    ips = Set::new ips
    monitoring_ips = Set::new Settings[:monitoring_hosts]
    from_monitoring_host = (ips.intersection(monitoring_ips).size > 0)
    monitoring_request = (status_json and from_monitoring_host)

    unless (params[:format] == "rss" or monitoring_request)
      authenticate_or_request_with_http_basic do |username, password|
        username == Settings[:admin][:username] and password == Settings[:admin][:password]
      end
    end
  end

  helper_method :latest_tweet
  def latest_tweet
    @latest_tweet ||= Tweet.in_order.first
  end

  helper_method :latest_deleted_tweet
  def latest_deleted_tweet
    @latest_deleted_tweet ||= DeletedTweet.in_order.first
  end

  helper_method :current_admin_rss
  def current_admin_rss
    "#{request.url}/#{Settings[:rss_secret]}.rss"
  end
end
