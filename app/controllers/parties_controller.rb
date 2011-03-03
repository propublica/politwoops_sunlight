class PartiesController < ApplicationController
  # GET /party/cda
  # GET /party/cda.xml
  def show    
    @politicians = Party.where(:name => params[:name]).first.politicians.all.map {|politician| politician.id}
    @tweets = Tweet.deleted.where(:politician_id => @politicians).paginate(:page => params[:page], :per_page => Tweet.per_page)

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
