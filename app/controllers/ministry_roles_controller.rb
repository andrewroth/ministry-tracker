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
  
  def manage_rp_trees




#pseudo code
  counter = 0
  @new_list.each |x| do
	 if x == @old_list [counter]
	   counter += 1
	 else
		# x has gone up
	#	if @backup.nil?
	#		@backup = x
	#	end
	#	mi_to_check = x.ministry_involvements
	#	position = 
	#	@mi_role_rpRolePosition_pairs = mi.collect do {|mi| [mi,person.rp.ministry_involvement.find_by_id(mi.ministry_id).ministry_role.position]}
	#	@mi_rpRolePosition_pairs.each do |pair|
	#	unless position > pair[2]
	#		pair[1].responsible_person_id = @backup.id
	#		pair[1].save
	#	end
	 end
	 @backup = x
  end
end
  
  
  
  
  
  
  
  
  
  
  def find_ministry_role
    @ministry_role = MinistryRole.find(params[:id])
  end
end