class TweetsController < ApplicationController
  # GET /tweets
  # GET /tweets.xml
  def index
    @group_name = params[:group_name] || @group_default_name
    @politicians = Politician.joins(:groups).where({:groups => {:name => @group_name}}).all
    @tweets = Tweet.deleted.where(:politician_id => @politicians).paginate(:page => params[:page], :per_page => Tweet.per_page)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  do
        response.headers["Content-Type"] = "application/xml; charset=utf-8"
        render
      end
      format.json { render :json => @tweets }
    end
  end

  # GET /tweets/1
  # GET /tweets/1.xml
  def show
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tweet }
      format.json  { render :json => @tweet }
    end
  end
end
