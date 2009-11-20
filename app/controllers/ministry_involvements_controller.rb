# Question: Seems to be a kind of CRUD for a person's involvement with a given
# ministry, but not complete CRUD?

class MinistryInvolvementsController < ApplicationController
  #before_filter :ministry_leader_filter, :except => :destroy
  before_filter :set_inv_type
  before_filter :set_ministries_and_roles, :only => [ :new, :create, :edit, :update ]

  # used to pop up a dialog box
  def index
    @from_profile = true
    unless is_staff_somewhere(@person)
      @denied = true
    else
      @ministry_involvements = @person.active_ministry_involvements
      @involvement_history = @person.involvement_history
    end
    render :template => 'involvements/index'
  end

  def new
    @ministry_involvement = @person.ministry_involvements.new
    render :template => 'involvements/new'
  end

  # Records the ending of a user's involvement with a particular ministry
  def destroy
    @person = Person.find(params[:person_id])
    if @me == @person || authorized?(:new, :people)
      @ministry_involvement = MinistryInvolvement.find(params[:id])
      @history = @ministry_involvement.new_staff_history
      @history.save
      @ministry_involvement.end_date = Date.today
      @ministry_involvement.save!
      @from_profile = params[:from_profile]

      respond_to do |format|
        format.xml  { head :ok }
        format.js {
          render :template => 'involvements/destroy' if params[:from_profile]
        }
      end
    else
      respond_to do |format|
        format.xml  { head :ok }
        format.js   do 
          render :update do |page|
            page.hide('spinner')
          end
        end
      end
    end
  end
  
  def create
    # If this person was already on this ministry, update with the new role
    mi = MinistryInvolvement.find(:first, :conditions => {_(:person_id, :ministry_involvement) => @person.id, _(:ministry_id, :ministry_involvement) => params[:ministry_involvement][:ministry_id] } )
    if mi
      mi.ministry_role_id = params[:ministry_involvement][:ministry_role_id]
      mi.start_date ||= Date.today
      if mi.archived?
        mi.end_date = nil
        mi.last_history_update_date = Date.today
      else
        @updated = true
      end
      mi.save
    else
      # TODO: check role is underneath current user's role, if student
      mi = MinistryInvolvement.create(params[:ministry_involvement].merge({
        :person_id => @person.id, :start_date => Date.today
      }))
    end
    @ministry_involvement = mi
    unless request.xhr?
      redirect_to '/staff'
    else
      @from_profile = true
      render :template => 'involvements/create'
    end
  end
  
  # A staff is defined as a anyone with a StaffRole.  But what really matters
  # is what their role gives them permission to do.
  # Staff are admin if they're marked admin in the ministry involvement.  The
  # actual role of being an admin doesn't inherently grant anything.
  def edit
    if params[:from_manage] == 'true'
      @ministry_involvement = @person.ministry_involvements.find params[:id]
      render :template => 'involvements/edit'
    elsif params[:person_id].present? && params[:ministry_id].present?
      @ministry_involvement = MinistryInvolvement.find(:first, :conditions => {:ministry_id => params[:ministry_id], :person_id => params[:person_id], :end_date => nil})
      unless @ministry_involvement
        flash[:notice] = "Couldn't find ministry involvement."
        redirect_to :back unless request.xhr?
        return
      end

      @person = @ministry_involvement.person
      @ministry_involvement.admin = @person.admin?(@ministry_involvement.ministry)
    else
      raise "Missing parameters"
    end
  end
  
  def update
    @ministry_involvement = MinistryInvolvement.find(params[:id])
    # We don't want someone accidentally removing their own admin privs, and only admins can set other admins
    params[:ministry_involvement][:admin] = @ministry_involvement.admin? if @ministry_involvement.person == @me || !is_ministry_admin(@ministry, @me)
    
    # And you can't set any roles higher than yourself
    unless possible_roles.collect(&:id).include?(params[:ministry_involvement][:ministry_role_id].to_i)
      flash[:notice] = "Sorry, you can't set that role"
      return
    end
    @person = @ministry_involvement.person 

    if @ministry_involvement.archived?
      @ministry_involvement.end_date = nil
      @ministry_involvement.last_history_update_date = Date.today
    end

    save_history = @ministry_involvement.ministry_role_id.to_s != params[:ministry_involvement][:ministry_role_id]
    @history = @ministry_involvement.new_staff_history if save_history
    @ministry_involvement.ministry_role_id = params[:ministry_involvement][:ministry_role_id]
    if @ministry_involvement.save
      @history.save if save_history
    end

    # special case when editing a single person's role
    if params[:single_edit]
      flash[:notice] = "#{@person.full_name}'s ministry role updated to #{@ministry_involvement.ministry_role.name}"
    end
    @from_profile = params[:from_profile]
    respond_to do |wants|
      wants.js {
        render :template => 'involvements/update' if params[:from_manage] == 'true'
      }
    end
  end
  
  protected

  def set_inv_type
    @plural = 'ministries'
    @singular = 'ministry'
    @short = 'mi'
    @add_title = 'Add Ministry / Team'
  end

  def set_ministries_and_roles
    @ministries = get_ministry.self_plus_descendants
    @roles = [ [ 'Staff Roles', StaffRole.all(:order => :position).collect{ |sr| [ sr.name, sr.id ] } ] ]
    @roles += [ [ 'Student Roles', StudentRole.all(:order => :position).collect{ |sr| [ sr.name, sr.id ] } ] ]
  end
end
