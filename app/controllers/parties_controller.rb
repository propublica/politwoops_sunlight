class PartiesController < ApplicationController

  def show    
    @politicians = Party.where(:name => params[:name]).first.politicians.active.map {|politician| politician.id}
    @tweets = DeletedTweet.includes(:politician => [:party]).where(:politician_id => @politicians, :approved => true).paginate(:page => params[:page], :per_page => Tweet.per_page)
    render "tweets/index"
  end

end