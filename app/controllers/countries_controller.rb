class CountriesController < ApplicationController
  # GET /groups
  # GET /groups.xml
  def index
    @groups = Group.country.order(:flag).all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
      format.json { render :json => @groups }
    end
  end
end
