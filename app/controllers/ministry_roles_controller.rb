class MinistryRolesController < ApplicationController
  layout 'manage'
  before_filter :find_ministry_role, :only => [:edit, :update, :destroy, :permissions]
  
  def index
    
  end
  
  def new
    @ministry_role = MinistryRole.new
  end
  
  def create
    type = params[:ministry_role].delete(:type)
    @ministry_role = type.constantize.new(params[:ministry_role])
    @ministry_role.ministry = get_ministry.root
    if @ministry_role.save
      render
    else
      render :action => :new
    end
  end
  
  def edit
    respond_to do |wants|
      wants.js
    end
  end
  
  def update
    if @ministry_role.update_attributes(params[:ministry_role])
      render
    else
      render :action => :edit
    end
  end
  
  def destroy
    @ministry_role.destroy if @ministry_role.ministry_involvements.empty?
    render :nothing => true
  end
  
  def permissions
    @permissions = Permission.find(:all, :order => 'controller, action')
  end
  
  def reorder
    offset = 0
    if roles = params['student_role_list']
      @ministry_roles = get_ministry.student_roles
      offset += get_ministry.staff_roles.count 
    elsif roles = params['other_role_list']
      offset += get_ministry.student_roles.length + get_ministry.staff_roles.count
      @ministry_roles = get_ministry.other_roles
    else
      roles = params['staff_role_list']
      @ministry_roles = get_ministry.staff_roles
    end
    if roles
      @new_list = roles
      @old_list = []
      counter = 1
      
      while counter > roles.length
        role = MinistryRole.find_by_position(counter + offset)
        @old_list << role
        counter += 1
      end
      
      @ministry_roles.each do |role|
        if roles.include?(role.id.to_s)
          role.position = roles.index(role.id.to_s) + 1 + offset
          role.save
        end
      end
      manage_rp_trees
    end
    render :nothing => true
  end
  
  protected
  
  #this is used to make sure that every rp is higher to that who they rp
  def manage_rp_trees
    counter = 0
    @new_list.each do |string_role|
      role_id = string_role.to_i
	    if role_id == @old_list [counter]
	      counter += 1
	    else # role has gone up
	      @backup_id ||= role_id
	      role = MinistryRole.find(role_id)
	      mis = role.ministry_involvements
	      position = role.position
	      #make pairs that have [ministry_involvements, rp's ministry_involvement]
	      @mi_rpRole_pairs = mis.collect {|mi| [mi, get_rps_ministry_involvement(mi)]}
	      @mi_rpRole_pairs.each do |pair|
	        unless pair[2].nil? || position > pair[2].minsitry_role.position
	          cur_min = pair[1].ministry
	          cur_camp = pair[1].person.most_recent_involvement
	          possible_mis = MinistryInvolvements.find(:all, :conditions => {:ministry_role_id => @backup_id, 
	                                                       :ministry_id => cur_min.id}).reject{|mi| mi.person.campuses.find_by_id(cur_camp.id).nil?}
	          new_rp_id = possible_mis.first.person_id
	          pair[1].responsible_person_id = new_rp_id
	 	        pair[1].save
	        end
	      end
	    end
	    @backup_id = role_id
    end
  end
  
  def get_rps_ministry_involvement(mi)
    mi.person.responsible_person ?  mi.person.responsible_person.ministry_involvements.find_by_id(mi.ministry_id) : nil
  end
 
  
  def find_ministry_role
    @ministry_role = MinistryRole.find(params[:id])
  end
end