class CampusInvolvementsController < ApplicationController
  before_filter :set_campuses
  before_filter :set_school_years
  before_filter :set_inv_type

  def index
    @campus_involvements = @person.campus_involvements
    render :template => 'involvements/index'
  end

  def new
    @campus_involvement = @person.campus_involvements.new :start_date => Date.today
    render :template => 'involvements/new'
  end

  def create
    params[:campus_involvement][:ministry_id] = get_ministry.id
    params[:campus_involvement][:start_date] ||= Date.today
    params[:campus_involvement][:person_id] = @person.id
    @campus_involvement = @person.campus_involvements.create(params[:campus_involvement])
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

  def update
    @campus_involvement = @person.campus_involvements.find params[:id]
    params[:campus_involvement][:ministry_id] = get_ministry.id
    if @campus_involvement.archived?
      @was_archived = true
      @campus_involvement.update_attributes params[:campus_involvement]
    end
    # NOTE: if involvement is not archived, the rjs invokes a destroy 
    # (which really only archives in this case) and new remote call, 
    # to create an archived involvement
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

  def (aci, cis = @person.campus_involvements)
    # figure out where to put the archived campus involvement
    archived_index = cis.index aci
    @archived_after = archived_index == 0 ? :first : cis[archived_index - 1]
  end

end
