class TrendsController < ApplicationController

  def index
    @year = params[:year] || Time.now.strftime('%Y')
    @month = params[:month] || Time.now.strftime('%m')
    @trends = Trend.where(:year => @year, :month => @month)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @trends }
    end
  end

end