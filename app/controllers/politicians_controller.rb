class PoliticiansController < ApplicationController
  def new
    @politician = Politician.new
  end
  
  def create
    @politician = Politician.new(params[:politician])
    if @politician.save
      flash[:notice] = "Politician added!"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end
  
  def edit
    @politician = Politician.find(params[:id])
  end

  def index
    @politicians = Politician.order(:user_name).all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @parties }
    end
  end
  
  # GET /politicians/FemkeHalsema
  # GET /politicians/GemkeHalsema.xml
  def show
    @tweets = Tweet.deleted.where(:user_name => params[:user_name]).paginate(:page => params[:page], :per_page => Tweet.per_page)

    respond_to do |format|
      format.html { render "tweets/index" }# show.html.erb
      format.xml  do
        response.headers["Content-Type"] = "application/xml; charset=utf-8"
        render "tweets/index"
      end
      format.json  { render :json => @tweets }
    end
  end
end
