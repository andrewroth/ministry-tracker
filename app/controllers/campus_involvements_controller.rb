class CampusInvolvementsController < ApplicationController
  before_filter :set_campuses
  before_filter :set_school_years
  before_filter :set_inv_type
  before_filter :set_roles, :only => [ :new, :edit ]
  before_filter :set_student, :only => [ :index, :new, :edit ]

  def index
    @campus_involvements = @person.active_campus_involvements
    @involvement_history = @person.involvement_history
    @from_profile = true
    render :template => 'involvements/index'
  end

  def new
    @campus_involvement = @person.campus_involvements.new :start_date => Date.today
    render :template => 'involvements/new'
  end

  def create
    # look for an existing one
    @campus_involvement = @person.campus_involvements.find :first, :conditions => { :campus_id => params[:campus_involvement][:campus_id] }
    @campus_involvement ||= @person.campus_involvements.new :start_date => Date.today, :ministry_id => get_ministry.id, :campus_id => params[:campus_involvement][:campus_id]
    @updated = !@campus_involvement.new_record?

    params[:campus_involvement][:school_year_id] = params[:campus_involvement][:school_year_id]
    # TODO: check that a student can only assign roles <= their own role
    update_campus_involvement
    if @campus_involvement.archived?
      @campus_involvement.end_date = nil
      @campus_involvement.last_history_update_date = Date.today
      @campus_involvement.save!
      @updated = false
    end

    @from_profile = true
    render :template => 'involvements/create'
  end

  def destroy
    @campus_involvement = CampusInvolvement.find(params[:id])
    destroy_campus_involvement
    respond_to do |format|
      format.xml  { head :ok }
      format.js { render :template => 'involvements/destroy' if params[:from_profile] == 'true' }
    end
    # else
    #      respond_to do |format|
    #        format.xml  { head :ok }
    #        format.js   do 
    #          render :update do |page|
    #            page.alert('You must leave at least one campus.')
    #            page.hide('spinner')
    #          end
    #        end
         # end
    # end
  end

  def edit
    @campus_involvement = @person.campus_involvements.find params[:id]
    @ministry_involvement = @campus_involvement.find_or_create_ministry_involvement
    render :template => 'involvements/edit'
  end

  def update_staff_campus_involvement
    record_history = @campus_involvement.school_year_id != params[:school_year_id]
    @campus_involvement.update_attributes :school_year_id => params[:campus_involvement][:school_year_id]
  end

  # record the mi history as well
  def update_student_campus_involvement
    @ministry_involvement = @campus_involvement.find_or_create_ministry_involvement
    record_history = !@campus_involvement.new_record? && 
      (@campus_involvement.school_year_id.to_s != params[:campus_involvement][:school_year_id] || 
      @ministry_involvement.ministry_role_id.to_s != params[:ministry_involvement][:ministry_role_id])
    if record_history
      @history = @campus_involvement.new_student_history
      @history.ministry_role_id = @ministry_involvement.ministry_role_id
    end
    @campus_involvement.update_attributes :school_year_id => params[:campus_involvement][:school_year_id]
    if record_history && @campus_involvement.errors.empty? && @ministry_involvement.errors.empty?
      @history.save!
      @campus_involvement.update_attributes :last_history_update_date => Date.today
    end
  end

  def update
    @campus_involvement = @person.campus_involvements.find params[:id]
    update_campus_involvement
    render :template => 'involvements/update'
  end

  def update_campus_involvement
    handle_campus_involvement do |is_student|
      if is_student
        update_student_campus_involvement
      else
        update_staff_campus_involvement
      end
    end
  end

  def destroy_campus_involvement
    handle_campus_involvement do |is_student|
      if is_student
        @history = @campus_involvement.new_student_history
        @history.ministry_role_id = @ministry_involvement.ministry_role_id
        @history.save!
        @campus_involvement.last_history_update_date = Date.today
      end
      @campus_involvement.end_date = Date.today
      @campus_involvement.save!
    end
  end

  def handle_campus_involvement
    current_role = get_ministry_involvement(get_ministry).try(:ministry_role) || 
      @campus_involvement.find_or_create_ministry_involvement.ministry_role
    yield current_role.nil? || current_role.is_a?(StudentRole)
  end

  protected

  def set_campuses
    @campuses = @person.ministries.collect &:campuses
    @campuses.flatten!
    @campuses.uniq!
  end

  def set_school_years
    @school_years = SchoolYear.all
  end

  def set_inv_type
    @plural = 'campuses'
    @singular = 'campus'
    @short = 'ci'
    @add_title = 'Add Campus'
  end

  def set_roles
    @roles = [ [ 'Student Roles', StudentRole.all(:order => :position).collect{ |sr| [ sr.name, sr.id ] } ] ]
    @default_role_id = MinistryRole.default_student_role.id
  end

  def set_student
    @staff = is_staff_somewhere(@person)
    @student = !@staff
  end
end
