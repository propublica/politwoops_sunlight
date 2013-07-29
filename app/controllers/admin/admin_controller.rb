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

    ip = (request.env['HTTP_X_FORWARDED_FOR'] or request.remote_ip)
    from_monitoring_host = configuration[:monitoring_hosts].include? ip
    monitoring_request = (status_json and from_monitoring_host)

    unless (params[:format] == "rss" or monitoring_request)
      authenticate_admin
      # authenticate_or_request_with_http_basic do |username, password|
      #   username == configuration[:admin][:username] and password == configuration[:admin][:password]
      # end
    end
  end

  helper_method :latest_tweet, :latest_deleted_tweet, :current_admin, :current_admin_rss
  
  def latest_tweet
    @latest_tweet ||= Tweet.first
  end
  
  def latest_deleted_tweet
    @latest_deleted_tweet ||= DeletedTweet.first
  end

  def current_admin
    @current_admin ||= session[:current_admin_id] ? Admin::Administrator.find(session[:current_admin_id]) : nil
  end
  
  def configuration
    @configuration ||= YAML.load_file "#{Rails.root}/config/config.yml"
  end
  
  def current_admin_rss
    "#{request.url}/#{configuration[:rss_secret]}.rss"
  end
  
  #######
  private
  #######
    
  def authenticate_admin
    authenticate_or_request_with_http_basic("Application") do |username, password|
      admin = Admin::Administrator.authenticate(username, password)
      
      if admin.nil?
        session[:current_admin_id] = nil
        render :text => "", :status => :unauthorized
        return false
      end
      session[:current_admin_id] = admin.id if admin
      
      return true
    end
  end
    
end
