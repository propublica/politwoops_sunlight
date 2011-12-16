class PartiesController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update]
  before_filter :require_admin_user, :only => [:destroy]
  
  def new
    @party = Party.new
  end
  
  def create
    @party = Party.new(params[:party])
    if @party.save
      redirect_to((current_user.is_admin == 1) ? parties_path : account_path, :notice => t(:success_create, :scope => [:politwoops, :parties]))
    else
      render :action => :new
    end
  end
  
  def edit
    @party = Party.find(params[:id])
  end

  # PUT /politicians/1
  # PUT /politicians/1.xml
  def update
    @party = Party.find(params[:id])

    respond_to do |format|
      if @party.update_attributes(params[:party])
        format.html { redirect_to((current_user.is_admin == 1) ? parties_path : account_path, :notice => t(:success_update, :scope => [:politwoops, :parties])) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @politician.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def index
    @parties = Party.order(:name).all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @parties }
    end
  end
  
  # GET /party/cda
  # GET /party/cda.xml
  def show    
    @politicians = Party.where(:name => params[:name]).first.politicians.active.map {|politician| politician.id}
    @tweets = DeletedTweet.includes(:politician => [:party]).where(:politician_id => @politicians).paginate(:page => params[:page], :per_page => Tweet.per_page)

    respond_to do |format|
      format.html { render "tweets/index" }# show.html.erb
      format.xml  do
        response.headers["Content-Type"] = "application/xml; charset=utf-8"
        render "tweets/index"
      end
      format.json  { render :json => @tweets.map{ |tweet| tweet.format } }
    end
  end

  # DELETE /party/1
  # DELETE /party/1.xml
  def destroy
    @party = Party.find(params[:id])
    @party.destroy

    respond_to do |format|
      format.html { redirect_to(parties_url) }
      format.xml  { head :ok }
    end
  end
end
