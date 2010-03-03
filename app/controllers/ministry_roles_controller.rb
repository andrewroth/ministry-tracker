# Manages the  roles associated with a given ministry.
# Three categories:
# * 'student_role_list'
# * 'other_role_list'
# * 'staff_role_list'

class MinistryRolesController < ApplicationController
  layout 'manage'
  before_filter :find_ministry_role, :only => [:edit, :update, :destroy, :permissions]
  skip_before_filter :authorization_filter, :only => :show
  skip_before_filter CASClient::Frameworks::Rails::GatewayFilter, :only => :show
  skip_before_filter :login_required, :only => :show
  skip_before_filter :get_ministry, :only => :show
  skip_before_filter :force_required_data, :only => :show
  
  def index
    # Force the user to be looking at the root ministry
    @ministry = current_ministry.root if current_ministry.root
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
  
  def show
    if params[:person_id] || params[:guid]
      if params[:guid]
        @user = User.find(:first, :conditions => {_(:guid, :user) => params[:guid]}, :include => :person)
        @person = @user.person
      else
        @person = Person.find(params[:person_id])
      end
      @ministry = Ministry.find(params[:ministry_id])
      if @person && @ministry
        mi = MinistryInvolvement.find(:first, :conditions => {:person_id => @person.id, :ministry_id => @ministry.id})
        @ministry_role = mi.ministry_role
        if @ministry_role
          respond_to do |wants|
            # wants.html { render @ministry_role.to_xml }
            wants.xml { render :xml => @ministry_role.to_xml }
          end
          return
        end
      end
    end
    render :nothing => true
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
      @ministry_roles.each do |role|
        if roles.include?(role.id.to_s)
          role.position = roles.index(role.id.to_s) + 1 + offset
          role.save
        end
      end
    end
    render :nothing => true
  end
  
  protected
  def find_ministry_role
    @ministry_role = MinistryRole.find(params[:id])
  end
end
