class TweetsController < ApplicationController
  # GET /tweets
  # GET /tweets.xml

  require 'RMagick'
  include ApplicationHelper

  caches_action :index, 
    :expires_in => 30.minutes,
    :if => proc { (params.keys - ['format', 'action', 'controller']).empty? }

  caches_action :thumbnail

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
      query = "%#{@query}%"
      @search_pols = Politician.where("MATCH(user_name, first_name, middle_name, last_name) AGAINST (?)", query)
      @tweets = @tweets.where("content like ? or deleted_tweets.user_name like ? or politician_id in (?)", query, query, @search_pols)
       
    end

    # only approved tweets
    @tweets = @tweets.where(:approved => true)

    @per_page_options = [20, 50]
    @per_page = closest_value((params.fetch :per_page, 0).to_i, @per_page_options)
    @page = [params[:page].to_i, 1].max

    @tweets = @tweets.includes(:tweet_images, :politician => [:party]).paginate(:page => params[:page], :per_page => @per_page)

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

  def thumbnail
    image = TweetImage.find(params[:id])
    if not image
      not_found
    end

    resp = HTTParty.get(image.url)
    img = Magick::Image.from_blob(resp.body)
    layer0 = img[0]
    aspect_ratio = layer0.columns.to_f / layer0.rows.to_f
    if aspect_ratio > 1.0
      new_width = 150
      new_height = layer0.rows.to_f / aspect_ratio
    else
      new_width = layer0.columns.to_f / aspect_ratio
      new_height = 150
    end
    thumb = layer0.resize_to_fit(new_width, new_height)
    filename = File.basename(URI.parse(image.url).path)
    send_data(thumb.to_blob,
              :disposition => 'inline',
              :type => resp.headers.fetch('content-type', 'application/octet-stream'),
              :filename => filename)
  end

end
