# Handles CRUD for involvements for a memeber and a given group at a given
# level of involvement
#

class GroupInvolvementsController < ApplicationController
  before_filter :set_group_involvement_and_group, :only => [ :accept_request, :decline_request, 
    :decline_request, :transfer, :change_level, :destroy, :joingroup ]
  before_filter :ensure_request_matches_group, :only => [ :accept_request, :decline_request ]

  def create
    get_person_campus_groups
    @groups = @person_campus_groups
    params[:requested] = false
    create_group_involvement
    @group = @gi.group
    @level = @gi.level
  end
  
  def joingroup
    unless %w(member interested).include?(params[:level])
      flash[:notice] = 'invalid level'
      render(:update) do |page|
        update_flash(page, flash[:notice])
      end
      return
    end
    params[:requested] = (params[:level] == 'member' ? @group.needs_approval : false)
    create_group_involvement
    get_person_campus_groups
    flash[:notice] = (@gi.requested ? "Join request for <b>#{@group.name}</b> group sent!" : 
                                      "You are now marked as <b>#{@gi.level.capitalize}</b> in the group <b>#{@group.name}</b>")
    @join = true
  end
  
  def accept_request
    get_person_campus_groups
    @gi_request.requested = false
    @gi_request.save!
    flash[:notice] = "Group join request from <b>" + @gi_request.person.full_name + "</b> accepted."
    render :action => 'request_result'
  end
  
  def decline_request
    get_person_campus_groups
    @gi_request.destroy
    flash[:notice] = "Group join request from <b>" + @gi_request.person.full_name + "</b> declined."
    render :action => 'request_result' 
  end
  
  def destroy 
    act_on_members do |gi|
      if gi.level == 'leader' && gi.group.leaders.count == 1
        @member_notices << "Couldn't remove #{gi.person.full_name}, since that would result in a leaderless group!"
      else
        @levels_to_update << gi.level
        @member_notices << "#{gi.person.full_name} removed"
        gi.destroy
      end
    end
  end
  
  # Moves members to another group
  def transfer
    @group_to_transfer_to = Group.find params[:transfer_to] # TODO: add some security
    act_on_members do |gi|
      if gi.level == 'leader' && gi.group.leaders.count == 1
        @member_notices << "Couldn't transfer #{gi.person.full_name}, since that would result in a leaderless group!"
      elsif @group_to_transfer_to.people.detect{ |p| p == gi.person }
        @member_notices << "#{gi.person.full_name} already in group #{@group_to_transfer_to.name}"
      else
        gi.group = @group_to_transfer_to
        @member_notices << "#{gi.person.full_name} transferred to #{@group_to_transfer_to.name}"
        @levels_to_update << gi.level
      end
    end
  end
  
  # group_involvements/id/change_level (level => ?)
  def change_level
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
        @member_notices << "Couldn't change #{gi.person.full_name}'s level from a leader, since that would result in a leaderless group!"
      else
        @levels_to_update << gi.level # update old
        gi.level = params[:level]
        @levels_to_update << gi.level # update new
        @member_notices << "#{gi.person.full_name} is now a #{params[:level]}"
      end
    end
  end
  
  def destroy_own
    @gi = GroupInvolvement.find(params[:id])
    @group = @gi.try(:group)
    if @gi && @group && @gi.person == @me
      @gi.destroy
    end
  end

  protected

  def act_on_members
    @member_notices = []
    @levels_to_update = []
    if params[:members]
      # try to transfer each member
      params[:members].each do |member|
        gi = @group.group_involvements.find(:first, :conditions => {:person_id => member})
        yield gi
        gi.save!
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
    
    def create_group_involvement
      # If the person is already in the group, find them. otherwise, create a new record
      @gi = find_by_person_id_and_group_id(params[:person_id], params[:group_id])
      @gi ||= GroupInvolvement.new(:person_id => params[:person_id], :group_id => params[:group_id])
      @gi.level = params[:level]
      @gi.requested = params[:requested]
      @gi.save!
    end

    def set_group_involvement_and_group
      @gi = GroupInvolvement.find :first, :conditions => { :id => params[:id] }
      @group = @gi ? @gi.group : Group.find(params[:group_id])
    end

    def ensure_request_matches_group
      @gi_request = @gi # actually the id is the request to be accepted/denied
      @gi = @gi.group.group_involvements.find_by_person_id @me.id
      unless (@gi && @gi_request) || is_staff_somewhere
        flash[:notice] = "You don't have permission to do this"
        access_denied
      end
    end
end
