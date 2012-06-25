class Admin::AdminController < ApplicationController
  before_filter :admin_only
  
  protected
  
  def admin_only
    authenticate_or_request_with_http_basic do |username, password|
      username == credentials[:username] and password == credentials[:password]
    end
  end
  
  def credentials
    @credentials ||= YAML.load_file "#{Rails.root}/config/admin.yml"
  end
end