class MinistryInvolvementsController < ApplicationController
  before_filter :ministry_leader_filter
  def destroy
    @person = Person.find(params[:person_id])
    if @person.all_ministries.size > 1
      @ministry_involvement = MinistryInvolvement.find(params[:id])
      @ministry_involvement.destroy

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