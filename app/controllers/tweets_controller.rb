class TweetsController < ApplicationController
  # GET /tweets
  # GET /tweets.xml

  include ApplicationHelper

  caches_action :index, 
    :expires_in => 30.minutes,
    :if => proc { (params.keys - ['format', 'action', 'controller']).empty? }

  before_filter :enable_filter_form

  def index
    @filter_action = "/"

    if params.has_key?(:see) && params[:see] == :all
      @tweets = Tweet
    else
      @tweets = DeletedTweet
    end

    @tweets = @tweets.where(:politician_id => @politicians)
    tweet_count = 0 #@tweets.count

    if params.has_key?(:q) and params[:q].present?
      # Rails prevents injection attacks by escaping things passed in with ?
      @query = params[:q]
      @query.strip!
      query = "%#{@query}%"
      puts (query) 
      @tweets = @tweets.joins(:politician).where(
        "content like ? or deleted_tweets.user_name like ? or concat_ws(' ', politicians.first_name, politicians.middle_name ,politicians.last_name) like ? or concat_ws(' ', politicians.first_name, politicians.middle_name) like ? or concat_ws(' ', politicians.first_name, politicians.last_name) like ?
        or concat_ws(' ', politicians.middle_name, politicians.last_name) like ?", query, query, query, query, query, query)
    end

    # only approved tweets
    @tweets = @tweets.where(:approved => true)

    @per_page_options = [20, 50, 100, 200]
    @per_page = closest_value((params.fetch :per_page, 0).to_i, @per_page_options)
    @page = [params[:page].to_i, 1].max

    @tweets = @tweets.includes(:politician => [:party]).paginate(:page => params[:page], :per_page => @per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.rss  do
        response.headers["Content-Type"] = "application/rss+xml; charset=utf-8"
        render
      end
      format.json { render :json => {:meta => {:count => tweet_count}, :tweets => @tweets.map{|tweet| tweet.format } } }
    end
  end

  # GET /tweets/1
  # GET /tweets/1.xml
  def show
    @tweet = DeletedTweet.includes(:politician).find(params[:id])

    if @tweet.politician.status != 1 and @tweet.politician.status != 4 and not @tweet.approved 
      not_found
    end	

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tweet }
      format.json  { render :json => @tweet.format }
    end
  end

  def shorten_url
    require 'httpi'
    require 'curb'
    require 'json'

    url = URI.escape("https://www.googleapis.com/urlshortener/v1/url")
     
    HTTPI.adapter = :curb
    req = HTTPI::Request.new
    req.url = url

    req.body = {"longUrl"=>params[:url]}.to_json

    req.headers = {"Accept" => "application/json", "Content-Type" => "application/json"}

    req.auth.gssnegotiate
    resp = HTTPI.post req do |http|
      http.use_ssl
    end
    @short_url = ""
    if resp.code == 200
      @short_url =  JSON.parse(resp.body)['id']
    end
    
    Rails.logger.warn "the whole reponse #{resp.body}"
    Rails.logger.warn "The shor URL is --> #{@short_url}"

    respond_to do |format|
        format.json { render }
    end

  end
end
