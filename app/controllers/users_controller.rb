class UsersController < ApplicationController
  # before_filter :authenticate, :only => :new
  before_filter :require_admin_or_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :require_admin_user, :only => [:destroy, :index]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account geregistreerd!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end
  
  def index
    @users = User.order(:login).all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account bijgewerkt!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  # DELETE /party/1
  # DELETE /party/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
