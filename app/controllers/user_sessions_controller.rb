class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  allow_http_basic_auth = false
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      #flash[:notice] = "You're in! You can go to the <a href=\"/account\">menu</a> now."
      flash[:notice] = "Je bent binnen! Je kunt nu naar het <a href=\"/account\">menu</a> gaan."
      redirect_back_or_default '/' # referer maybe? else account_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    #flash[:notice] = "You're out!"
    flash[:notice] = "Je bent velig uitgelogd!"
    redirect_back_or_default '/login' # new_user_session_url
  end
end