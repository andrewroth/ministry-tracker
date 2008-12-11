class MinistryRolePermissionsController < ApplicationController

  # POST /ministry_role_permissions
  # POST /ministry_role_permissions.xml
  def create
    # Make sure it doesn't already exist (possible double-click)
    @ministry_role_permission = MinistryRolePermission.find(:first, :conditions => params[:ministry_role_permission])
    @ministry_role_permission ||= MinistryRolePermission.new(params[:ministry_role_permission])

    respond_to do |format|
      if @ministry_role_permission.save
        flash[:notice] = 'MinistryRolePermission was successfully created.'
        format.xml  { render :xml => @ministry_role_permission, :status => :created, :location => @ministry_role_permission }
        format.js
      else
        format.xml  { render :xml => @ministry_role_permission.errors, :status => :unprocessable_entity }
        format.js   { render :nothing => true}
      end
    end
  end

  # DELETE /ministry_role_permissions/1
  # DELETE /ministry_role_permissions/1.xml
  def destroy
    @ministry_role_permission = MinistryRolePermission.find(params[:id])
    @ministry_role_permission.destroy

    respond_to do |format|
      format.xml  { head :ok }
      format.js   {render :action => :create}
    end
  end
end
