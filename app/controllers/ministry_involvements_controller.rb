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
      @ministry_involvements = @person.ministry_involvements
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
      if !is_admin? &&
        @ministry_involvement.ministry.name == Cmt::CONFIG[:default_ministry_name] &&
        @ministry_involvement.ministry_role.is_a?(StaffRole)
        respond_to do |format|
          format.js   do
            render :update do |page|
              page.hide('spinner')
              page.alert("Sorry, you can't remove the #{Cmt::CONFIG[:default_ministry_name]} involvement")
            end
          end
        end
        return
      end
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
    # Only staff can create ministry_involvements
    unless is_staff_somewhere(@me)
      flash[:notice] = "Only staff can set ministry involvement"
      redirect_to :back
      return
    end
    person_id = params[:ministry_involvement] && params[:ministry_involvement][:person_id] ? params[:ministry_involvement][:person_id] : params[:person_id]
    @person = Person.find(person_id)

    @student_before = !is_staff_somewhere(@person)

    # If this person was already on this ministry, update with the new role
    mis = MinistryInvolvement.find(:all, :conditions => {_(:person_id, :ministry_involvement) => @person.id, _(:ministry_id, :ministry_involvement) => params[:ministry_involvement][:ministry_id] } )

    # handle case where there are multiple mis for this ministry
    # we might lose history and the proper start date, but this case is rare enough
    # that I think it's worth it -AR
    if mis.length > 1
      first = true
      for mi in mis
        first ? first = false : mi.delete
      end
    end
    mi = mis.first

    # update the mi
    if mi
      mi.ministry_role_id = params[:ministry_involvement][:ministry_role_id]
      mi.start_date ||= Date.today
      if mi.archived? || (@student_before && mi.ministry_role.is_a?(StaffRole))
        mi.end_date = nil
        mi.last_history_update_date = Date.today
      else
        @updated = true
      end
      save_history = mi.ministry_role_id.to_s != params[:ministry_involvement][:ministry_role_id]
      @history = mi.new_staff_history if save_history
      mi.ministry_role_id = params[:ministry_involvement][:ministry_role_id]
      if mi.save
        @history.save if save_history
      end
    else
      mi = MinistryInvolvement.create!(params[:ministry_involvement].merge({
        :person_id => @person.id, :start_date => Date.today
      }))
    end
    @ministry_involvement = mi
    @promoted = @student_before && mi.ministry_role.is_a?(StaffRole)
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
    @default_role_id = MinistryRole.default_staff_role.id
  end
end
