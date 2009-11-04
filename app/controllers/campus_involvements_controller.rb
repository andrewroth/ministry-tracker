class CampusInvolvementsController < ApplicationController
  before_filter :set_campuses
  before_filter :set_school_years
  before_filter :set_inv_type

  def index
    @campus_involvements = @person.active_campus_involvements
    @involvement_history = @person.involvement_history
    render :template => 'involvements/index'
  end

  def new
    @campus_involvement = @person.campus_involvements.new :start_date => Date.today
    render :template => 'involvements/new'
  end

  def create
    # look for an existing one
    ci = @person.campus_involvements.find :first, :campus_id => params[:campus_involvement][:campus_id]
    ci ||= @person.campus_involvements.new

    params[:campus_involvement][:ministry_id] = get_ministry.id
    params[:campus_involvement][:start_date] ||= Date.today
    params[:campus_involvement][:end_date] = nil
    params[:campus_involvement][:person_id] = @person.id
    ci.new_student_history unless ci.new_record?
    ci.update_attributes params[:campus_involvement]

    render :template => 'involvements/create'
  end

  def destroy
    # if @person.campus_involvements.count > 1
    @campus_involvement = CampusInvolvement.find(params[:id])
    if @campus_involvement.end_date.present?
      @campus_involvement.destroy
    else
      @archived_campus_involvement = @campus_involvement
      setup_archived_after(@archived_campus_involvement)
      @campus_involvement.update_attribute(:end_date, Date.today)
    end
    respond_to do |format|
      format.xml  { head :ok }
      format.js { render :template => 'involvements/destroy' if params[:from_manage] == 'true' }
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
    render :template => 'involvements/edit'
  end

  def update_staff_campus_involvement
    record_history = @campus_involvement.school_year_id != params[:school_year_id]
    @campus_involvement.update_attributes :school_year_id => params[:campus_involvement][:school_year_id]
  end

  # record the mi history as well
  def update_student_campus_involvement
    @ministry_involvement = @campus_involvement.find_or_create_ministry_involvement
    record_history = @campus_involvement.school_year_id.to_s != params[:school_year_id] || 
      @ministry_involvement.ministry_role_id.to_s != params[:ministry_role_id]
    if record_history
      @student_history = @campus_involvement.new_student_history
      @student_history.ministry_role_id = @ministry_involvement.ministry_role_id
    end
    @campus_involvement.update_attributes :school_year_id => params[:campus_involvement][:school_year_id]
    @ministry_involvement.update_attributes :ministry_role_id => StudentRole.first # TODO
    if record_history && @campus_involvement.errors.empty? && @ministry_involvement.errors.empty?
      @student_history.save!
    end
  end

  def update
    debugger
    @campus_involvement = @person.campus_involvements.find params[:id]
    current_role = get_ministry_involvement(get_ministry).try(:ministry_role) || 
      @campus_involvement.find_or_create_ministry_involvement.ministry_role

    if current_role.nil? || current_role.is_a?(StudentRole)
      update_student_campus_involvement
    else
      update_staff_campus_involvement
    end
 
    render :template => 'involvements/update'
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

  def setup_archived_after(aci, cis = @person.campus_involvements)
    # figure out where to put the archived campus involvement
    archived_index = cis.index aci
    @archived_after = archived_index == 0 ? :first : cis[archived_index - 1]
  end

end
