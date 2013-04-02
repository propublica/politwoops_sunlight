class PoliticiansController < ApplicationController

  include ApplicationHelper

  caches_action :show,
    :expires_in => 5.minutes,
    :if => proc { (params.keys - ['format', 'action', 'controller']).empty? }

  def show
    @per_page_options = [20, 50]
    @per_page = closest_value((params.fetch :per_page, 0).to_i, @per_page_options)
    @page = [params[:page].to_i, 1].max

    @politician = Politician.active.where(:user_name => params[:user_name]).first
    not_found unless @politician
    
    # need to get the latest tweet to get correct bio. could do with optimization :)
    @latest_tweet = Tweet.where(:politician_id => @politician.id).first
    
    @tweets = DeletedTweet.includes(:politician => [:party]).where(:approved => true, :politician_id => @politician.id).paginate(:page => params[:page], :per_page => @per_page)

    @politicians = Politician.active

    @related = @politician.get_related_politicians() #get ids of related accounts
    @accounts = Politician.where(:id => @related.push(@politician.id))

    @all_tweets = DeletedTweet.where(:politician_id => @related.push(@politician.id), :approved =>true).paginate(:page => params[:page], :per_page => @per_page)  

    @tweet_map = {} 
    @accounts.each do |ac|
        @tweet_map[ac.user_name] = DeletedTweet.where(:politician_id => ac, :approved => true).paginate(:page => params[:page], :per_page => @per_page)
    end

    @tweet_map['all'] = @all_tweets

    respond_to do |format|
      format.html { render } # politicians/show
      format.rss  do
        response.headers["Content-Type"] = "application/rss+xml; charset=utf-8"
        render "tweets/index"
      end
    end
  end

  before_filter :enable_filter_form
  def all 
    
    @per_page_options = [20, 50]
    @per_page = closest_value((params.fetch :per_page, 0).to_i, @per_page_options)
    @page = [params[:page].to_i, 1].max
    
    @filter_action = "/users"

    #get all politicians that we're showing
    @politicians = @politicians.order('last_name').where(:status => [1, 4]).paginate(:page => params[:page], :per_page => @per_page)

    respond_to do |format|
      format.html {render}
    end
  end

end 
