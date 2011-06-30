class TwitterUsersController < ApplicationController
  before_filter :require_user, :only => [:index]
  before_filter :set_twitter, :only => [:index]
  
  def index
    @twitter_users = []
    @politicians = {}
    search_params = {
      :per_page => 10,
      :page => 1
    }
    
    if params.has_key?(:q)
      @twitter_users = @twitter_client.user_search(params[:q], search_params)
      @twitter_users.each do |twitter_user|
        @politicians[twitter_user.screen_name] = Politician.new({
          :user_name => twitter_user.screen_name,
          :twitter_id => twitter_user.id
        })
      end
      @politicians_users = Politician.where(:user_name => @politicians.keys)
      @politicians_users.each do |politician|
        @politicians[politician.user_name] = politician
      end
      p @politicians
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @twitter_users }
    end
  end
end
