# encoding: utf-8
class PoliticiansController < ApplicationController
  include ApplicationHelper

  before_filter :enable_pager
  before_filter :enable_filter_form, only: :index

  caches_action :show,
    :expires_in => 5.minutes,
    :if => proc { (params.keys - ['format', 'action', 'controller']).empty? }

  def show
    @politician = Politician.active.where(:user_name => params[:user_name]).first

    not_found unless @politician
    
    # need to get the latest tweet to get correct bio. could do with optimization :)
    @latest_tweet = Tweet.in_order.where(:politician_id => @politician.id).first

    @related = @politician.get_related_politicians().to_a.sort_by(&:user_name)
    @accounts = [@politician] + @related

    @tweet_map = {}
    @accounts.each do |ac|
      @tweet_map[ac.user_name] = ac.twoops.in_order.includes(:tweet_images).paginate(:page => @page, :per_page => @per_page)
    end

    if @tweet_map.size == 1
      @tweet_map['all'] = @tweets = @tweet_map.values.first
    else
      @tweet_map['all'] = @tweets = DeletedTweet.in_order.includes(:tweet_images).where(:politician_id => @accounts.map(&:id), :approved => true).paginate(:page => @page, :per_page => @per_page)
    end

    respond_to do |format|
      format.html { render } # politicians/show
      format.rss  do
        response.headers["Content-Type"] = "application/rss+xml; charset=utf-8"
        render "tweets/index"
      end
    end
  end

  def index
    @filter_action = "/users"
    @politicians = @politicians.order('last_name').where(:status => [1, 4])

    respond_to do |format|
      format.html {
        @politicians = @politicians.paginate(:page => params[:page], :per_page => @per_page)
        render
      }

      format.csv {
        render :csv => @politicians
      }
    end
  end
end 
