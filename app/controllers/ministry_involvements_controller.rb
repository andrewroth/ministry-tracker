class MinistryInvolvementsController < ApplicationController
  before_filter :ministry_leader_filter, :except => :destroy
  def destroy
    @person = Person.find(params[:person_id])
    if @me == @person || is_ministry_leader
      @ministry_involvement = MinistryInvolvement.find(params[:id])
      @ministry_involvement.update_attribute(:end_date, Time.now)

      respond_to do |format|
        format.xml  { head :ok }
        format.js
      end
    else
      respond_to do |format|
        format.xml  { head :ok }
        format.js   do 
          render :update do |page|
            page.alert('You must leave at least one ministry.')
            page.hide('spinner')
          end
        end
      end
    end
  end
  
  def edit
    if params[:person_id] && params[:ministry_id]
      @ministry_involvement = MinistryInvolvement.find(:first, :conditions => {:ministry_id => params[:ministry_id], :person_id => params[:person_id]})
      @staff = Person.find(params[:person_id])
      @ministry_involvement.admin = @staff.admin?(@ministry_involvement.ministry)
      @possible_roles = get_ministry.ministry_roles.find(:all, :conditions => "#{_(:position, :ministry_roles)} >= #{@my.role(get_ministry).position}")
    else
      raise "Missing parameters"
    end
  end
  
  def update
    @ministry_involvement = MinistryInvolvement.find(params[:id])
    # We don't want someone screwing themselves over by accidentally removing admin privs
    params[:ministry_involvement][:admin] = @ministry_involvement.admin? if @ministry_involvement.person == @me
    @ministry_involvement.update_attributes(params[:ministry_involvement])
    @staff = @ministry_involvement.person
    respond_to do |wants|
      wants.js {  }
    end
  end
end