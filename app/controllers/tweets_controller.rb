class TweetsController < ApplicationController
  # GET /tweets
  # GET /tweets.xml
  def index
    @tweets = Tweet.deleted.paginate(:page => params[:page], :per_page => Tweet.per_page)
    
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
