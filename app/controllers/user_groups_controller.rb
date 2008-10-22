class UserGroupsController < ApplicationController
  def new
    @user_group = @ministry.user_groups.build
    render :update do |page|
      page[:permissions].visual_effect :drop_out
      page[:user_group].replace_html :partial => 'new'
      page[:user_group].show
      page[:user_group_name].focus
    end
  end
  
  def create
    @user_group = @ministry.user_groups.build(params[:user_group])
    if @user_group.save
      flash[:notice] = @user_group.name+' group was created successfully.'
      render :update do |page|
        update_flash(page, flash[:notice])
        page[:manage].replace_html :partial => 'permissions/index'
      end
    else
      render :update do |page|
        page[:permissions].replace_html :partial => 'new'
      end
    end
  end
  
  def edit
    @user_group = @ministry.user_groups.find(params[:id], :include => :permissions)
    @permissions = Permission.find(:all, :order => 'name') - @user_group.permissions
    render :update do |page|
      page[:manage].replace_html :partial => 'edit'
    end
  end
  
  def destroy
    @user_group = @ministry.user_groups.find(params[:id])
    flash[:notice] = @user_group.name + ' was successufully deleted.'
    @user_group.destroy
    render :update do |page|
      page[:permissions].replace_html :partial => 'permissions/index'
      update_flash(page, flash[:notice])
    end
  end
end