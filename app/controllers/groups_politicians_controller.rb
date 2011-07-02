class GroupsPoliticiansController < ApplicationController
  def update
    @group = Group.find(params[:id])
    politicians_in_group = @group.politician_ids
    if !politicians_in_group.include?(params[:politician_id].to_i)
      politicians_in_group << params[:politician_id].to_i
      respond_to do |format|
        if @group.update_attributes :politician_ids => politicians_in_group
          format.html { redirect_to((current_user.is_admin == 1) ? groups_path : account_path, :notice => t(:success_update, :scope => [:politwoops, :groups_politicians]) ) }
        else
          format.html { redirect_to edit_group_path(@group) }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to((current_user.is_admin == 1) ? groups_path : account_path, :notice => t(:success_update, :scope => [:politwoops, :groups_politicians]) ) }
      end
    end
  end
end
