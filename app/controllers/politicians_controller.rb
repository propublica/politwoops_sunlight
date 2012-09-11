class PoliticiansController < ApplicationController

  def show
    @politician = Politician.active.where(:user_name => params[:user_name]).first
    not_found unless @politician
    
    # need to get the latest tweet to get correct bio. could do with optimization :)
    @latest_tweet = Tweet.where(:politician_id => @politician.id).first
    
    @tweets = DeletedTweet.includes(:politician => [:party]).where(:approved => true, :politician_id => @politician.id).paginate(:page => params[:page], :per_page => Tweet.per_page)

    respond_to do |format|
      format.html { render } # politicians/show
      format.rss  do
        response.headers["Content-Type"] = "application/rss+xml; charset=utf-8"
        render "tweets/index"
      end
    end
  end

  def admin_list
    @politicians = Politician.all
    respond_to do |format|
      format.html { render } 
    end
  end

  def admin_user
    @politician = Politician.find(params[:id]) || raise("not found")
    @parties = Party.all
    @offices = Office.all
    @account_types = AccountType.all
    
    respond_to do |format|
      format.html { render }
    end
  end

  def save_user
    pol = Politician.find(params[:id]) || raise("not found")
    pol.user_name = params[:user_name]
    pol.party = Party.find(params[:party_id])
    pol.status = params[:status]
    if params[:account_type_id] == '0' then
      pol.account_type = nil
    else
      pol.account_type = AccountType.find(params[:account_type_id])
    end
    if params[:office_id] == '0' then
      pol.office = nil
    else
      pol.office = Office.find(params[:office_id])
    end
    if params[:first_name] != '' and params[:first_name].strip != ' ' then
      pol.first_name = params[:first_name]
    end
    if params[:middle_name] != '' and params[:middle_name].strip != ' ' then
      pol.middle_name = params[:middle_name]
    end
    if params[:last_name] != '' and params[:last_name].strip != ' ' then
      pol.last_name = params[:last_name]
    end
    if params[:suffix] != '' and params[:suffix].strip != ' ' then
      pol.suffix = params[:suffix]
    end
    pol.save()

    redirect_to :back
  end

end
