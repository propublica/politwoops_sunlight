class Admin::PoliticiansController < Admin::AdminController 
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
    @related = Politician.where(:id=> @politician.get_related_politicians())
    
    @unmoderated = DeletedTweet.where(:reviewed=>false, :politician_id => @politician).length
 
    respond_to do |format|
      format.html { render }
    end
  end

  def new_user
    @parties = Party.all
    @offices = Office.all
    @account_types = AccountType.all

    respond_to do |format|
      format.html { render }
    end
  end

  def get_twitter_id
    require 'twitter'
    t = Twitter.user(params[:screen_name])
    @twitter_id = t.id
    respond_to do |format|
        format.json { render }
    end
  end 

  def save_user
    if params[:id] == '0' then
      #it's a new add
      pol = Politician.new(:twitter_id => params[:twitter_id], :user_name => params[:user_name])
    else
      pol = Politician.find(params[:id]) || raise("not found")
      pol.user_name = params[:user_name]
    end
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
    if params[:state] != '' and params[:state].strip != ' ' then
      pol.state = params[:state]
    end
    
    pol.save()

    if params[:unapprove_all] and params[:unapprove_all] == 'on' then
        unmod = DeletedTweet.where(:reviewed=>false, :politician_id => pol)
        unmod.each do |utweet|
            utweet.approved = 0
            utweet.review_message = "Bulk unapproved in admin"
            utweet.reviewed = 1
            utweet.reviewed_at = Time.now 
            utweet.save()

        end
    end

    if params[:related] then
      names = params[:related].split(',')
      names.each do |uname|
      if uname.length > 0 and uname != ' ' and uname.strip != '' then
          begin
            namepol = Politician.where(:user_name => uname.strip).first
            if namepol then
              pol.add_related_politician(namepol)
            end
          rescue
            next
          end
        end
      end
    end


    redirect_to :back
  end

end
