class Admin::AdministratorsController < Admin::AdminController
  
  def index
    @admin_administrators = Admin::Administrator.all

    respond_to do |format|
      format.html
    end
  end
  
  def new
    @admin_administrator = Admin::Administrator.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @admin_administrator = Admin::Administrator.find(params[:id])
  end
  
  def create
    @admin_administrator = Admin::Administrator.new(params[:admin_administrator])
    @admin_administrator.password = params[:admin_administrator][:password]
    @admin_administrator.password_confirmation = params[:admin_administrator][:password_confirmation]
    
    respond_to do |format|
      if @admin_administrator.save
        format.html { redirect_to admin_administrators_url, :notice => 'Administrator was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @admin_administrator = Admin::Administrator.find(params[:id])
    @admin_administrator.attributes = params[:admin_administrator]
    @admin_administrator.password = params[:admin_administrator][:password]
    @admin_administrator.password_confirmation = params[:admin_administrator][:password_confirmation]

    respond_to do |format|
      if @admin_administrator.save
        format.html { redirect_to admin_administrators_url, :notice => 'Administrator was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @admin_administrator = Admin::Administrator.find(params[:id])
    @admin_administrator.destroy

    respond_to do |format|
      format.html { redirect_to admin_administrators_url }
    end
  end
end
