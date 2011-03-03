class PoliticiansController < ApplicationController
  # GET /politicians/FemkeHalsema
  # GET /politicians/GemkeHalsema.xml
  def show
    @tweets = Tweet.deleted.where(:user_name => params[:user_name]).paginate(:page => params[:page], :per_page => Tweet.per_page)

    respond_to do |format|
      format.html { render "tweets/index" }# show.html.erb
      format.xml  { render :xml => @tweet }
      format.json  { render :json => @tweet }
    end
  end
end
