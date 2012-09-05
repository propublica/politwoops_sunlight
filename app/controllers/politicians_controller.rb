class PoliticiansController < ApplicationController

  # GET /politicians/FemkeHalsema
  # GET /politicians/GemkeHalsema.xml
  def show
    @politician = Politician.active.where(:user_name => params[:user_name]).first
    
    # need to get the latest tweet to get correct bio. could do with optimization :)
    @latest_tweet = Tweet.where(:politician_id => @politician.id).first
    
    @tweets = DeletedTweet.includes(:politician => [:party]).where(:approved => true, :politician_id => @politician.id).paginate(:page => params[:page], :per_page => Tweet.per_page)

    respond_to do |format|
      format.html { render }
      format.rss  do
        response.headers["Content-Type"] = "application/rss+xml; charset=utf-8"
        render "tweets/index"
      end
      format.json  { render :json => @tweets.map{ |tweet| tweet.format } }
    end
  end
end