class CampusInvolvementsController < ApplicationController
  before_filter :set_campuses
  before_filter :set_school_years
  before_filter :set_inv_type

  def index
    @campus_involvements = @person.active_campus_involvements
    render :template => 'involvements/index'
  end

  def new
    @campus_involvement = @person.campus_involvements.new
    render :template => 'involvements/new'
  end

  def create
    params[:campus_involvement][:ministry_id] = get_ministry.id
    params[:campus_involvement][:start_date] = Date.today
    @campus_involvement = @person.campus_involvements.create(params[:campus_involvement])
    render :template => 'involvements/create'
  end

  def destroy
    # if @person.campus_involvements.count > 1
    @campus_involvement = CampusInvolvement.find(params[:id])
    @campus_involvement.update_attribute(:end_date, Time.now)
    respond_to do |format|
      format.xml  { head :ok }
      format.js
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
    @campus_involvement.update_attributes params[:campus_involvement]
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
end
