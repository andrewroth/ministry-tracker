class GroupInvitationsController < ApplicationController
  unloadable

  def new
    @group = Group.find(params[:group_id].to_i)
    @group_invitation = GroupInvitation.new({:group_id => params[:group_id].to_i})
    
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @group_invitation = GroupInvitation.new(params[:group])
  end
end
