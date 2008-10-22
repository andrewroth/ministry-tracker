class UserMembershipsController < ApplicationController
  def index
    @user_groups = @ministry.user_groups.find(:all)
    render :update do |page|
      page[:manage].replace_html :partial => 'index'
    end
  end
  
  def group
    @user_group = @ministry.user_groups.find(params[:user_group_id])
    render :update do |page|
      page[:manage].replace_html :partial => 'group'
    end
  end
end