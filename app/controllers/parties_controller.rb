class PartiesController < ApplicationController
  # GET /party/cda
  # GET /party/cda.xml
  def show    
    @politicians = Party.where(:name => params[:name]).first.politicians.all.map {|politician| politician.id}
    @tweets = Tweet.deleted.where(:politician_id => @politicians).paginate(:page => params[:page], :per_page => Tweet.per_page)

    respond_to do |format|
      format.html { render "tweets/index" }# show.html.erb
      format.xml  { render :xml => @tweet }
      format.json  { render :json => @tweet }
    end
  end
end
