class UserGroupPermissionsController < ApplicationController
  def index
    @user_groups = @ministry.user_groups
    render :update do |page|
      page[:manage].replace_html :partial => 'index'
    end
  end
  
  def create
    params[:permissions].each do |permission_id|
      UserGroupPermission.create(:permission_id => permission_id, :user_group_id => params[:user_group_id]) unless permission_id.to_i == 0
    end
    reload
  end
  
  def destroy 
    UserGroupPermission.delete_all(["id IN (?)", params[:user_group_permissions]])
    reload
  end
  
  protected
    def reload
      @user_group = @ministry.user_groups.find(params[:user_group_id])
      @permissions = Permission.find(:all, :order => 'name') - @user_group.permissions
      render :update do |page|
        page[:user_group_select].reload
        page[:permissions_select].reload
      end
    end
end