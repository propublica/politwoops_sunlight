class TweetsController < ApplicationController
  # GET /tweets
  # GET /tweets.xml
  def index
    page_size = 10
    @tweets = Tweet.where(:deleted => 1)
    
    @tweets = @tweets.offset(params[:offset] * page_size) if params.has_key?(:offset)
    
    @tweets = @tweets.limit(page_size)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tweets }
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
