class AccountadminVieweraccessgroupsController < ApplicationController
  unloadable
  layout 'manage'

  # GET /accountadmin_users/1/accountadmin_vieweraccessgroups
  # GET /accountadmin_users/1/accountadmin_vieweraccessgroups.xml
  def index
    @user = User.find(params[:accountadmin_user_id])

    @accessgroup_checked = {}

    @accountadmin_accessgroups = AccountadminAccessgroup.all

    @accountadmin_accesscategories = AccountadminAccesscategory.all

    @accountadmin_accessgroups.each do |accessgroup|
      if accessgroup.accountadmin_vieweraccessgroups.find(:first, :conditions => {:viewer_id => @user.id}) then
        @accessgroup_checked.merge!({accessgroup.id => true})
      else
        @accessgroup_checked.merge!({accessgroup.id => false})
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accountadmin_languages }
    end
  end

  
  def change
    @user = User.find(params[:user_id])
    @accessgroup = AccountadminAccessgroup.find(params[:accessgroup_id])
    @join = @accessgroup.accountadmin_vieweraccessgroups.find(:first, :conditions => {:viewer_id => @user.id})

    if @join then
      if @join.destroy then
        render(:text => "success")
      else
        flash[:notice] = 'OOPS! Could not remove the access group!'
        render(:update) { |page| page.redirect_to accountadmin_user_accountadmin_vieweraccessgroups_url(@user)}
      end
    else
      @join = AccountadminVieweraccessgroup.new
      @join.viewer_id = params[:user_id]
      @join.accessgroup_id = params[:accessgroup_id]

      if @join.save then
        render(:text => "success")
      else
        flash[:notice] = 'OOPS! Could not add the access group!'
        render(:update) { |page| page.redirect_to accountadmin_user_accountadmin_vieweraccessgroups_url(@user)}
      end
    end
  end

end
