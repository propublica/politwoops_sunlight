class PoliticiansController < ApplicationController

  def show
    @politician = Politician.active.where(:user_name => params[:user_name]).first
    not_found unless @politician
    
    # need to get the latest tweet to get correct bio. could do with optimization :)
    @latest_tweet = Tweet.where(:politician_id => @politician.id).first
    
    @tweets = DeletedTweet.includes(:politician => [:party]).where(:approved => true, :politician_id => @politician.id).paginate(:page => params[:page], :per_page => Tweet.per_page)

    @states_list = Politician.all(:select => "DISTINCT(state)")
    @states = []
    @states_list.each do |sl|
      if sl.state != nil 
        @states.push(sl.state)
      end
    end
    @states = @states.sort

    @parties = Party.all
    @offices = Office.all

    @politicians = Politician.active

    #check for filters
    @filters = {'state' => nil, 'party' => nil, 'office' => nil  }
    if params.has_key?(:state) && params[:state] != ""
        @politicians = @politicians.where(:state => params[:state])
        @filters['state'] = params[:state]
    end
    if params.has_key?(:party) && params[:party] != ""
        party = Party.where(:name => params[:party])[0]
        @politicians = @politicians.where(:party_id => party)
        @filters['party'] = party.name
    end
    if params.has_key?(:office) && params[:office] != ""
        @politicians = @politicians.where(:office_id => params[:office])
        @filters['office'] = params[:office]
    end

    respond_to do |format|
      format.html { render } # politicians/show
      format.rss  do
        response.headers["Content-Type"] = "application/rss+xml; charset=utf-8"
        render "tweets/index"
      end
    end
  end

  def all 
    #get all politicians that we're showing
    @politicians = Politician.where(:status => [1, 4])
    respond_to do |format|
      format.html {render}
    end
  end

end 
