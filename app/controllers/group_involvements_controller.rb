# Handles CRUD for involvements for a memeber and a given group at a given
# level of involvement
#
# Question: def Transfer: not sure what it does

class GroupInvolvementsController < ApplicationController
  before_filter :set_group_involvement, :only => [ :accept_request, :decline_request, 
    :decline_request, :transfer, :change_level, :destroy ]
  before_filter :ensure_request_matches_group, :only => [ :accept_request, :decline_request ]
  before_filter :ensure_group_leader_or_coleader, :only => [ :accept_request, 
    :decline_request, :transfer, :change_level, :destroy ]

  def create
    create_group_involvement
    refresh_directory_page
  end
  
  def joingroup  
    params[:type] = params[:group_involvement][:level]
    params[:group_id] = params[:group_involvement][:group_id]
    @group_type_id = params[:gt_id]
    @group_id = params[:group_involvement][:group_id]
    get_person_campus_groups
    create_group_involvement
    flash[:notice] = "Join request for <b>#{@group.name}</b> group sent!"
  end
  
  def accept_request
    @gi_request.requested = false
    @gi_request.save!
    flash[:notice] = "Group join request from <b>" + @gi.person.full_name + "</b> accepted."
    render :action => 'request_result'
  end
  
  def decline_request
    @gi.destroy
    flash[:notice] = "Group join request from <b>" + @gi.person.full_name + "</b> declined."
    render :action => 'request_result' 
  end
  
  def destroy 
    @group = @gi.group
    if params[:members]
      leaders_to_delete_count = 0
      gis = []
      params[:members].each do |member|
        gi = find_by_person_id_and_group_id(member, params[:group_id])
        gi.destroy if gi
        leaders_to_delete_count += 1 if gi.level == 'leader'
      end
      # check that we don't delete all the leaders
      if leader_count < @group.leaders.count
        gis.each do |gi|
          gis.destroy
        end
      else 
        flash[:notice] = "You can not delete all the leaders in a groups"
      end
    else
      raise "No members were selected to delete"
    end
    get_group
    refresh_directory_page
  end
  
  def transfer
    @group = @gi.group
    @group_to_transfer_to = Group.find params[:transfer_to] # TODO: add some security
    act_on_members do |gi|
      gi.group_id = params[:transfer_id]
      @member_notices << "#{@gi.person.full_name} transferred to #{@group_to_transfer_to}"
      @levels_to_update << gi.level
    end
  end
  
  # group_involvements/id/change_level (level => ?)
  def change_level
    @group = @gi.group
    if Group::LEVEL_TITLES.include?(params[:level])
      params[:level] = Group::LEVELS[Group::LEVEL_TITLES.index(params[:level])]
    end
    unless Group::LEVELS.include?(params[:level])
      flash[:notice] = 'invalid level'
      render(:update) do |page|
        update_flash(page, flash[:notice])
      end
      return
    end

    act_on_members do |gi|
      if gi.level == 'leader' && gi.group.leaders.count == 1
        @member_notices << "Couldn't change #{@gi.person.full_name}'s level from a leader, since that would result in a leaderless group!"
      else
        @levels_to_update << gi.level # update old
        gi.level = params[:level]
        @levels_to_update << gi.level # update new
        @member_notices << "#{@gi.person.full_name} is now a #{params[:level]}"
      end
    end
  end
  
  protected

  def act_on_members
    @member_notices = []
    @levels_to_update = []
    if params[:members]
      # try to transfer each member
      params[:members].each do |member|
        begin
          gi = @group.group_involvements.find(:first, :conditions => {:person_id => member})
          yield gi
          gi.save!
        rescue ActiveRecord::StatementInvalid
          @member_notices << "Error for <i>" + gi.person.full_name
        end
      end
    else
      @member_notices << "People need to be selected"
    end
    @levels_to_update.compact!
    @levels_to_update.uniq!
    flash[:notice] = @member_notices.join('<br/>')
  end

    def find_by_person_id_and_group_id(person_id, group_id)
      GroupInvolvement.find(:first, :conditions => [_(:person_id, :group_involvement) + " = ? AND " + 
                                                          _(:group_id, :group_invovlement) + " = ? ", 
                                                          person_id, group_id])
    end
    
    def refresh_directory_page
      respond_to do |format|
        format.html do 
          redirect_to "/#{@group.class.to_s.tableize}/#{params[:group_id]}"
        end
        format.js do
          render :update do |page|
            eval("@#{@group.class.to_s.underscore} = @group" )
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

    def set_group_involvement
      @gi = GroupInvolvement.find params[:id]
    end

    def ensure_group_leader_or_coleader
      # make sure we're valid
      unless @gi.person == @me && (@gi.group.leaders.include?(@me) || @gi.group.leaders.include?(@me))
        flash[:notice] = "You don't have permission to do this"
        access_denied
      end
    end

    def ensure_request_matches_group
      @gi_request = @gi # actually the id is the request to be accepted/denied
      @gi = @gi.group.group_involvements.find_by_person_id @me.id
      unless @gi && @gi_request
        flash[:notice] = "You don't have permission to do this"
        access_denied
      end
    end
end
