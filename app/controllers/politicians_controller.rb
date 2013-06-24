class PoliticiansController < ApplicationController

  include ApplicationHelper

  def show
    @per_page_options = [20, 50, 100, 200]
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
    
    @per_page_options = [20, 50, 100, 200]
    @per_page = closest_value((params.fetch :per_page, 0).to_i, @per_page_options)
    @page = [params[:page].to_i, 1].max
    
    @filter_action = "/users"

    #get all politicians that we're showing
    @politicians = @politicians.where(:status => [1, 4]).paginate(:page => params[:page], :per_page => @per_page)

    respond_to do |format|
      format.html {render}
    end
  end

  def get_twitter_id
    #require 'twitter'
    user = Twitter.user(params[:screen_name])
    @twitter_id = user.id
    @org_profile_image = user.profile_image_url(:original)
    @profile_image = user.profile_image_url(:normal)
    
    names_list = user.name.split

    if names_list.length >=3
      @fname = names_list[0]
      @mname = names_list[1]
      @lname = names_list[2]
    elsif names_list.length >=2
      @fname = names_list[0]
      @lname = names_list[1]
    elsif names_list.length >=1
      @fname = names_list[0]
    end

    respond_to do |format|
        format.json { render }
    end
  end

  def suggest
    @parties = Party.all
    @politician = Politician.new()

    respond_to do |format|
      format.html { render }
    end
  end

  def send_suggestion
    @politician = Politician.new(:twitter_id => params[:twitter_id], :user_name => params[:user_name])
    if params[:party_id] == '0'
      @politician.party = nil
    else
      @politician.party = Party.find(params[:party_id])
    end
    if params[:first_name] != '' and params[:first_name].strip != ' ' then
      @politician.first_name = params[:first_name]
    end
    if params[:middle_name] != '' and params[:middle_name].strip != ' ' then
      @politician.middle_name = params[:middle_name]
    end
    if params[:last_name] != '' and params[:last_name].strip != ' ' then
      @politician.last_name = params[:last_name]
    end
    if params[:suffix] != '' and params[:suffix].strip != ' ' then
      @politician.suffix = params[:suffix]
    end

    name = params[:name]
    email = params[:email]

    if @politician.valid? and !name.empty? and (email =~ /@/)
      UserMailer.suggest_politician(@politician, name, email).deliver
      redirect_to("/")
    elsif @politician.valid?
      @user_error = t(:user_error, :scope =>[:politwoops, :error])
      @parties = Party.all
      render 'suggest'
    else
      @parties = Party.all
      render 'suggest'
    end

  end

end 
