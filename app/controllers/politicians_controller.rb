class PoliticiansController < ApplicationController
  def new
    @politician = Politician.new
  end
  
  def create
    # find the twitter user number
    params[:politician][:twitter_id] = Twitter::user(params[:politician][:user_name]).id
    
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

  # PUT /politicians/1
  # PUT /politicians/1.xml
  def update
    @politician = Politician.find(params[:id])
    # find the twitter user number
    params[:politician][:twitter_id] = Twitter::user(params[:politician][:user_name]).id

    respond_to do |format|
      if @politician.update_attributes(params[:politician])
        format.html { redirect_to(politicians_path, :notice => 'Politician was successfully updated.') }
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
