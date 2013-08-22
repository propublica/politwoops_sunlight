class Admin::SysSettingsController < Admin::AdminController
  def index
    @admin_sys_settings = Admin::SysSetting.scoped
  end
  
  def edit
    @admin_sys_setting = Admin::SysSetting.find(params[:id])
  end

  def update
    @admin_sys_setting = Admin::SysSetting.find(params[:id])

    respond_to do |format|
      if @admin_sys_setting.update_attributes(params[:admin_sys_setting])
        format.html { redirect_to admin_sys_settings_path, :notice => 'Sys setting was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end
end