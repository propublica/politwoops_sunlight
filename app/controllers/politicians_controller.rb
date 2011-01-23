class PoliticiansController < ApplicationController
  # GET /politicians/FemkeHalsema
  # GET /politicians/GemkeHalsema.xml
  def show
    page_size = 10
    @tweets = Tweet.deleted.where(:user_name => params[:user_name])
    
    @tweets = @tweets.offset(params[:offset].to_i * page_size) if params.has_key?(:offset)
    
    @tweets = @tweets.limit(page_size)

    respond_to do |format|
      format.html { render "tweets/index" }# show.html.erb
      format.xml  { render :xml => @tweet }
      format.json  { render :json => @tweet }
    end
  end
end
