# encoding: utf-8
class PartiesController < ApplicationController

  include ApplicationHelper
  before_filter :enable_filter_form

  def show    
    @per_page_options = [20, 50]
    @per_page = closest_value((params.fetch :per_page, 0).to_i, @per_page_options)
    @page = [params[:page].to_i, 1].max

    @politicians = Party.where(:name => params[:name]).first.politicians.active.map {|politician| politician.id}
    @tweets = DeletedTweet.includes(:politician => [:party]).where(:politician_id => @politicians, :approved => true).paginate(:page => params[:page], :per_page => Tweet.per_page)
    render "tweets/index"
  end

end
