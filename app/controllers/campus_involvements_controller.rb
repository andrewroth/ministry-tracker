class CampusInvolvementsController < ApplicationController
  def index
  end

  def new
    @campus_involvement = @person.campus_involvements.new
    @campuses = Campus.all
    @school_years = SchoolYear.all
  end

  def create
    conditions = params[:campus_involvement].merge(:ministry_id => get_ministry.id)
    @campus_involvement = @person.campus_involvements.find :first, :conditions => {
      :campus_id => conditions[:campus_id], :ministry_id => conditions[:ministry_id] 
    }
    if @campus_involvement
      @campus_involvement.update_attributes conditions
      @updated = true
    else
      @campus_involvement = @person.campus_involvements.create! conditions
    end
    @campuses = Campus.all
    @school_years = SchoolYear.all
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
    @campuses = Campus.all
    @school_years = SchoolYear.all
  end

  def update
    @campus_involvement = @person.campus_involvements.find params[:id]
    params[:campus_involvement][:ministry_id] = get_ministry.id
    params[:campus_involvement][:person_id] = @person.id
    if ci2 = CampusInvolvement.find(:first, :conditions => {
      :campus_id => params[:campus_id], :ministry_id => params[:ministry_id]
    })
      @campus_involvement.destroy # otherwise will get duplicate key error
      @campus_involvement = ci2
    end
    @campus_involvement.update_attributes params[:campus_involvement]
  end
end
