class TwitterUsersController < ApplicationController
  before_filter :require_user, :only => [:index]
  before_filter :set_twitter, :only => [:index]
  
  def index
    @twitter_users = []
    @politicians = {}
    
    if params.has_key?(:q)
      @twitter_users = @twitter_client.user_search(params[:q])
      @twitter_users.each do |twitter_user|
        @politicians[twitter_user.screen_name] = Politician.new({
          :user_name => twitter_user.screen_name,
          :twitter_id => twitter_user.id
        })
      end
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @twitter_users }
    end
  end
end
