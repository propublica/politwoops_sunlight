class TwitterListsController < ApplicationController

  def index
    @twitter_list_members = Twitter.list_members(params[:user_name], params[:list])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end
  
  def new
    @twitter_list = TwitterList.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
    @twitter_list = TwitterList.new(params[:twitter_list])
    if @twitter_list.valid?
      redirect_to '/twitter_lists/index/'
    else
      render :action => 'new'
    end
  end
end
