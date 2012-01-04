class GroupsController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update]
  before_filter :require_admin_user, :only => [:destroy]
  
  # GET /groups
  # GET /groups.xml
  def index
    if current_user && (current_user.is_admin != 1)
      @groups = Group.local.visible.all
    else
      @groups = Group.local.all
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
      format.json { render :json => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        # save the group id with the user
        if @current_user.is_admin != 1
          @current_user.update_attributes(:group_id => @group[:id])
        end
        
        format.html { redirect_to((current_user.is_admin == 1) ? groups_path : account_path, :notice => t(:success_create, :scope => [:politwoops, :groups])) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to((current_user.is_admin == 1) ? groups_path : account_path, :notice => t(:success_update, :scope => [:politwoops, :groups]) ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to((current_user.is_admin == 1) ? groups_path : account_path) }
      format.xml  { head :ok }
    end
  end
end
