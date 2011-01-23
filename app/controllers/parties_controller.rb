class PartiesController < ApplicationController
  # GET /party/cda
  # GET /party/cda.xml
  def show
    page_size = 10
    
    @politicians = Party.where(:name => params[:name]).first.politicians.all.map {|politician| politician.id}
    @tweets = Tweet.deleted.where(:politician_id => @politicians)
    
    @tweets = @tweets.offset(params[:offset].to_i * page_size) if params.has_key?(:offset)
    
    @tweets = @tweets.limit(page_size)

    respond_to do |format|
      format.html { render "tweets/index" }# show.html.erb
      format.xml  { render :xml => @tweet }
      format.json  { render :json => @tweet }
    end
  end
end
