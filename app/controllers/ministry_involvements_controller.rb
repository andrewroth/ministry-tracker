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
  
  # Staff are admin if they're marked admin in the ministry involvement.  The
  # actual role of being an admin doesn't inherently grant anything.
  def edit
    if params[:person_id] && params[:ministry_id]
      @ministry_involvement = MinistryInvolvement.find(:first, :conditions => {:ministry_id => params[:ministry_id], :person_id => params[:person_id]})
      @person = @ministry_involvement.person
      @ministry_involvement.admin = @person.admin?(@ministry_involvement.ministry)
      @possible_roles = get_ministry.ministry_roles.find(:all, :conditions => "#{_(:position, :ministry_roles)} >= #{@my.role(get_ministry).position}")
      # remove all 'Other' roles for now
      @possible_roles.reject! { |r| r.class == OtherRole }
      # if staff, allow all student roles
      @possible_roles += StudentRole.all
      @possible_roles.uniq!
    else
      raise "Missing parameters"
    end
  end
  
  def update
    @ministry_involvement = MinistryInvolvement.find(params[:id])
    # We don't want someone screwing themselves over by accidentally removing admin privs
    params[:ministry_involvement][:admin] = @ministry_involvement.admin? if @ministry_involvement.person == @me
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
