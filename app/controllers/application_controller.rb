class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_default_group
  
  helper_method :current_user_session, :current_user

  protected
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "politwoops" && password == "hackdeoverheid"
    end
  end
    
  private

  def set_default_group
    group_name = params.has_key?(:group_name) ? params[:group_name] : request.host.sub(/^www\./i, '')
    @default_group = Group.where(:name => group_name).first
    #set the language too
    I18n.locale = @default_group.language
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_admin_user 
    unless current_user && (current_user.is_admin == 1)
      store_location 
      flash[:notice] = "You must be an admin to access this page" 
      redirect_to new_user_session_url
      return false 
    end 
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def require_admin_or_no_user
    if current_user && (current_user.is_admin != 1)
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
