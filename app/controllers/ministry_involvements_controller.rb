# Question: Seems to be a kind of CRUD for a person's involvement with a given
# ministry, but not complete CRUD?

class MinistryInvolvementsController < ApplicationController
  before_filter :ministry_leader_filter, :except => :destroy

  # Records the ending of a user's involvement with a particular ministry
  def destroy
    @person = Person.find(params[:person_id])
    if @me == @person || authorized?(:new, :people)
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
            page.hide('spinner')
          end
        end
      end
    end
  end
  
  def create
    # If this person was already on this ministry, update with the new role
    @mi = MinistryInvolvement.find(:first, :conditions => {_(:person_id, :ministry_involvement) => params[:ministry_involvement][:person_id], _(:ministry_id, :ministry_involvement) => params[:ministry_involvement][:ministry_id]})
    @mi ? @mi.update_attribute(:ministry_role_id, params[:ministry_involvement][:ministry_role_id]) : MinistryInvolvement.create!(params[:ministry_involvement])
    redirect_to '/staff'
  end
  
  # A staff is defined as a student leader or anyone with a StaffRole
  # Staff are admin if they're marked admin in the ministry involvement.  The
  # actual role of being an admin doesn't inherently grant anything.
  def edit
    if params[:person_id] && params[:ministry_id]
      @ministry_involvement = MinistryInvolvement.find(:first, :conditions => {:ministry_id => params[:ministry_id], :person_id => params[:person_id]})
      unless @ministry_involvement
        flash[:notice] = "Couldn't find ministry involvement."
        redirect_to :back
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
    params[:ministry_involvement][:admin] = @ministry_involvement.admin? if @ministry_involvement.person == @me ||
    !is_ministry_admin(@ministry, @me)
    
    # And you can't set any roles higher than yourself
    unless possible_roles.collect(&:id).include?(params[:ministry_involvement][:ministry_role_id].to_i)
      flash[:notice] = "Sorry, you can't set that role"
      return
    end
    @ministry_involvement.update_attributes(params[:ministry_involvement])
    @person = @ministry_involvement.person
    # special case when editing a single person's role
    if params[:single_edit]
      flash[:notice] = "#{@person.full_name}'s ministry role updated to #{@ministry_involvement.ministry_role.name}"
    end
    respond_to do |wants|
      wants.js {  }
    end
  end
  
end
