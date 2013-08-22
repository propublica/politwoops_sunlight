class Admin::PoliticiansController < Admin::AdminController 
  
  def admin_list
    @politicians = Politician.scoped
    @politicians = @politicians.where(:party_id => params[:party_id]) unless params[:party_id].blank?
    @politicians = @politicians.where(:status => params[:status]) unless params[:status].blank?
    @politicians = @politicians.where(:auto_publish => params[:auto_publish]) unless params[:auto_publish].blank?
    
    @not_reviewed_tweets_count = DeletedTweet.where(:reviewed=>false).count(:group=>:politician_id)
    
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
 
    respond_to do |format|
      format.html { render }
    end
  end

  def new_user
    @parties = Party.all
    @offices = Office.all
    @account_types = AccountType.all
    @politician = Politician.new()

    respond_to do |format|
      format.html { render }
    end
  end

  def get_twitter_id
    #require 'twitter'
    user = Twitter.user(params[:screen_name])
    
    @twitter_id = user.id
    @twitter_id.inspect
    @org_profile_image = user.profile_image_url(:original)
    @org_profile_image.inspect
    @profile_image = user.profile_image_url(:normal)
    @profile_image.inspect
    
    names_list = [] 
    names_list = user.name.split if !user.name.nil? and !user.name.empty?

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
  
  def disable 
    @politician = Politician.find(params[:id])
    @politician.status = 3
    @politician.save
    if params[:page]
      redirect_to "/admin/review/?page=" + params[:page]
    else
      redirect_to "/admin/review/"
    end 
  end
  
  def save_user

    if params[:id] == '0' then
      #it's a new add
      @politician = Politician.new(:twitter_id => params[:twitter_id], :user_name => params[:user_name])
    else
      @politician = Politician.find(params[:id]) || raise("not found")
      @politician.user_name = params[:user_name]
    end

    if params[:party_id] == '0'
      @politician.party = nil
    else
      @politician.party = Party.find(params[:party_id])
    end

    @politician.status = params[:status]
    if params[:account_type_id] == '0' then
      @politician.account_type = nil
    else
      @politician.account_type = AccountType.find(params[:account_type_id])
    end
    
    if params[:office_id] == '0' then
      @politician.office = nil
    else
      @politician.office = Office.find(params[:office_id])
    end
    
    if params[:auto_publish] then
      @politician.auto_publish = true
    else
      @politician.auto_publish = false
    end
    
    #if params[:first_name] != '' and params[:first_name].strip != ' ' then
      @politician.first_name = params[:first_name]
    #end
    #if params[:middle_name] != '' and params[:middle_name].strip != ' ' then
      @politician.middle_name = params[:middle_name]
    #end
    #if params[:last_name] != '' and params[:last_name].strip != ' ' then
      @politician.last_name = params[:last_name]
    #end
    #if params[:suffix] != '' and params[:suffix].strip != ' ' then
      @politician.suffix = params[:suffix]
    #end
    
    if params[:profile_image] != nil and params[:profile_image] != '' and params[:profile_image].strip != ' ' then
      @politician.profile_image_url = params[:profile_image]
    end

    if @politician.save
      redirect_to("/admin/users")
    else
      @parties = Party.all
      @offices = Office.all
      @account_types = AccountType.all
      render 'new_user'
    end

    if !params[:related].nil? && params[:related] != '' then
      names = params[:related].split(',')
      names.each do |uname|
        begin
          namepol = Politician.where(:user_name => uname.strip).first
          politician.add_related_politician(namepol)
        rescue
          next
        end
      end
    end

    #redirect_to :back
  end
  
  def update
    if params[:politician_ids]
      where_cond = {}
      where_cond[:party_id] = params[:party_id] unless params[:party_id].blank?
      where_cond[:status] = params[:status] unless params[:status].blank?
      where_cond[:auto_publish] = params[:auto_publish] unless params[:auto_publish].blank?  
      
      Politician.update_all(where_cond, 
                              "id in (#{params[:politician_ids].join(', ')})") if where_cond.any?
    end
    redirect_to "/admin/users/"
  end
end