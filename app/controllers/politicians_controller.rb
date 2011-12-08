class PoliticiansController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update]
  before_filter :require_admin_user, :only => [:destroy]

  def new
    @politician = Politician.new(params[:politician])
  end
  
  def create
    # find the twitter user number
    params[:politician][:twitter_id] = Twitter::user(params[:politician][:user_name]).id
    
    # always save to default groups (default + users) if not an admin
    if (current_user.is_admin != 1)
      params[:politician][:group_ids] = [@default_group.id]
      unless current_user.group_id.nil?
        params[:politician][:group_ids] << current_user.group_id
      end
    end
    
    @politician = Politician.new(params[:politician])
    if @politician.save
      redirect_to (current_user.is_admin == 1) ? politicians_path : account_path, :notice => t(:success_create, :scope => [:politwoops, :politicians])
    else
      render :action => :new
    end
  end
  
  def edit
    @politician = Politician.find(params[:id])
  end

  # PUT /politicians/1
  # PUT /politicians/1.xml
  def update
    params[:politician][:group_ids] ||= []
    
    @politician = Politician.find(params[:id])
    # find the twitter user number
    begin
      params[:politician][:twitter_id] = Twitter::user(params[:politician][:user_name]).id      
    rescue Twitter::NotFound => e
      
    end
    

    respond_to do |format|
      if @politician.update_attributes(params[:politician])
        format.html { redirect_to(politicians_path, :notice => t(:success_update, :scope => [:politwoops, :politicians])) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @politician.errors, :status => :unprocessable_entity }
      end
    end
  end

  def index
    @politicians = Politician.order(:user_name).all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @politicians }
    end
  end
  
  # GET /politicians/FemkeHalsema
  # GET /politicians/GemkeHalsema.xml
  def show
    if current_user && (current_user.is_admin == 1)
      @politician = Politician
    else
      @politician = Politician.active
    end
    @politician = @politician.where(:user_name => params[:user_name]).first
    
    # need to get the latest tweet to get correct bio. could do with optimization :)
    @latest_tweet = Tweet.where(:politician_id => @politician.id).first
    
    @tweets = Tweet.deleted.includes(:politician => [:party]).where(:politician_id => @politician.id).paginate(:page => params[:page], :per_page => Tweet.per_page)

    respond_to do |format|
      format.html #{ render "tweets/index" }# show.html.erb
      format.xml  do
        response.headers["Content-Type"] = "application/xml; charset=utf-8"
        render "tweets/index"
      end
      format.json  { render :json => @tweets.map{ |tweet| tweet.format } }
    end
  end

  # DELETE /politicians/1
  # DELETE /politicians/1.xml
  def destroy
    @politician = Politician.find(params[:id])
    @politician.destroy

    respond_to do |format|
      format.html { redirect_to(polticians_url) }
      format.xml  { head :ok }
    end
  end
end
