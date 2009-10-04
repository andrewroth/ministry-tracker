class CampusInvolvementsController < ApplicationController
  before_filter :set_campuses
  before_filter :set_school_years

  def index
    @campus_involvements = @person.active_campus_involvements
  end

  def new
    @campus_involvement = @person.campus_involvements.new
  end

  def create
    params[:campus_involvement][:ministry_id] = get_ministry.id
    params[:campus_involvement][:start_date] = Date.today
    @campus_involvement = @person.campus_involvements.create(params[:campus_involvement])
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
  end

  def update
    @campus_involvement = @person.campus_involvements.find params[:id]
    params[:campus_involvement][:ministry_id] = get_ministry.id
    @campus_involvement.update_attributes params[:campus_involvement]
  end

  protected

  def set_campuses
    @campuses = get_ministry.campuses
  end

  def set_school_years
    @school_years = SchoolYear.all
  end
end
