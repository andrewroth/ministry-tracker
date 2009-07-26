# Handles CRUD for involvements for a memeber and a given group at a given
# level of involvement
#
# Question: def Transfer: not sure what it does

class GroupInvolvementsController < ApplicationController
  before_filter :get_group_involvement, :only => [ :accept_request, :decline_request ]
  before_filter :ensure_group_leader_or_coleader, :only => [ :accept_request, :decline_request ]

  # TODO: make sure that destroy and transfer check security

  def create
    create_group_involvement
    refresh_page
  end
  
  def joingroup  
    params[:type] = params[:group_involvement][:level]
    params[:group_id] = params[:group_involvement][:group_id]
    params[:requested] = true # force request for now as security feature
    @group_type_id = params[:gt_id]
    create_group_involvement
    flash[:notice] = "Join request for <b>#{@group.name}</b> group sent!"
  end
  
  def accept_request
    @gi.update_attribute(:requested, false)
    flash[:notice] = "Group join request from <b>" + @gi.person.full_name + "</b> accepted."
    render :action => 'request_result'
  end
  
  def decline_request
    @gi = GroupInvolvement.find(params[:id])
    @gi.destroy

    flash[:notice] = "Group join request from <b>" + @gi.person.full_name + "</b> declined."
    render :action => 'request_result' 
  end
  
  def destroy 
    if params[:members]
      params[:members].each do |member|
        gi = find_by_person_id_and_group_id(member, params[:id])
        GroupInvolvement.delete(gi.id)
      end
    else
      raise "No members were selected to delete"
    end
    get_group
    refresh_page
  end
  
  def transfer_selected
    @transfer_notices = []
    if params[:members]
      @group = Group.find(params[:id])
      # try to transfer each member
      params[:members].each do |member|
        begin
          gi = @group.group_involvements.find(:first, :conditions => {:person_id => member})
          gi.update_attribute(:group_id, params[:transfer_to])
        rescue ActiveRecord::StatementInvalid
          @transfer_notices << "Transfer failed: <i>" + gi.person.full_name + "</i> already in group " + @group.name
        end
      end
    else
      @transfer_notices << "People need to be selected before initiating a transfer."
    end
    get_group
    refresh_page
  end
  
  
  protected
    def find_by_person_id_and_group_id(person_id, group_id)
      GroupInvolvement.find(:first, :conditions => [_(:person_id, :group_involvement) + " = ? AND " + 
                                                          _(:group_id, :group_invovlement) + " = ? ", 
                                                          person_id, group_id])
    end
    
    def refresh_page
      respond_to do |format|
        format.html do 
          redirect_to "/#{@group.class.to_s.tableize}/#{params[:id]}"
        end
        format.js do
          render :update do |page|
            eval("@#{@group.class.to_s.underscore} =  @group")
            page[@group.class.to_s.underscore].replace_html(:partial => "#{@group.class.to_s.tableize}/show")
          end
        end
      end
    end

    def create_group_involvement
      # If the person is already in the group, find them. otherwise, create a new record
      @gi = find_by_person_id_and_group_id(params[:person_id], params[:group_id])
      @gi ||= GroupInvolvement.new(:person_id => params[:person_id], :group_id => params[:group_id])
      @gi.level = params[:type]  # set the level of involvement
      @gi.requested = params[:requested]
      @gi.save!
      @group = @gi.group
    end

    def get_group_involvement
      @gi = GroupInvolvement.find params[:id]
    end

    def ensure_group_leader_or_coleader
      # make sure we're valid
      unless @gi.group.leaders.include?(@me) || @gi.group.leaders.include?(@me)
        flash[:notice] = "You don't have permission to do this"
        redirect_to access_denied
      end
    end
end
