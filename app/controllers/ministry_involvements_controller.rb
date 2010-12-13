# Question: Seems to be a kind of CRUD for a person's involvement with a given
# ministry, but not complete CRUD?

class MinistryInvolvementsController < ApplicationController
  #before_filter :ministry_leader_filter, :except => :destroy
  before_filter :set_inv_type
  before_filter :set_ministries_and_roles, :only => [ :new, :create, :edit, :update ]

  # used to pop up a dialog box
  def index
    @from_profile = true
    unless is_staff_somewhere(@person)
      @denied = true
    else
      @ministry_involvements = @person.ministry_involvements
      @involvement_history = @person.involvement_history
    end
    render :template => 'involvements/index'
  end

  def new
    @ministry_involvement = @person.ministry_involvements.new
    render :template => 'involvements/new'
  end

  # Records the ending of a user's involvement with a particular ministry
  def destroy
    @person = Person.find(params[:person_id])
    if @me == @person || authorized?(:new, :people)
      @ministry_involvement = MinistryInvolvement.find(params[:id])
      if !is_admin? &&
        @ministry_involvement.ministry.name == Cmt::CONFIG[:default_ministry_name] &&
        @ministry_involvement.ministry_role.is_a?(StaffRole)
        respond_to do |format|
          format.js   do
            render :update do |page|
              page.hide('spinner')
              page.alert("Sorry, you can't remove the #{Cmt::CONFIG[:default_ministry_name]} involvement")
            end
          end
        end
        return
      end
      @history = @ministry_involvement.new_history
      @history.save
      @ministry_involvement.end_date = Date.today
      @ministry_involvement.save!
      @from_profile = params[:from_profile]

      respond_to do |format|
        format.xml  { head :ok }
        format.js {
          render :template => 'involvements/destroy' if params[:from_profile]
        }
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
    # Only staff can create ministry_involvements
    unless is_staff_somewhere(@me)
      flash[:notice] = "Only staff can set ministry involvement"
      redirect_to :back
      return
    end
    person_id = params[:ministry_involvement] && params[:ministry_involvement][:person_id] ? params[:ministry_involvement][:person_id] : params[:person_id]
    @person = Person.find(person_id)

    @student_before = !is_staff_somewhere(@person)

    # If this person was already on this ministry, update with the new role
    mis = MinistryInvolvement.find(:all, :conditions => {_(:person_id, :ministry_involvement) => @person.id, _(:ministry_id, :ministry_involvement) => params[:ministry_involvement][:ministry_id] } )

    # handle case where there are multiple mis for this ministry
    # we might lose history and the proper start date, but this case is rare enough
    # that I think it's worth it -AR
    if mis.length > 1
      first = true
      for mi in mis
        first ? first = false : mi.delete
      end
    end
    mi = mis.first

    # update the mi
    if mi
      mi.ministry_role_id = params[:ministry_involvement][:ministry_role_id]
      mi.start_date ||= Date.today
      if mi.archived? || (@student_before && mi.ministry_role.is_a?(StaffRole))
        mi.end_date = nil
        mi.last_history_update_date = Date.today
      else
        @updated = true
      end
      save_history = mi.ministry_role_id.to_s != params[:ministry_involvement][:ministry_role_id]
      @history = mi.new_history if save_history
      mi.ministry_role_id = params[:ministry_involvement][:ministry_role_id]
      if mi.save
        @history.save if save_history
      end
    else
      mi = MinistryInvolvement.create!(params[:ministry_involvement].merge({
        :person_id => @person.id, :start_date => Date.today
      }))
    end
    @ministry_involvement = mi
    @promoted = @student_before && mi.ministry_role.is_a?(StaffRole)
    if @promoted
      @person.archive_all_student_ministry_involvements
    end
    unless request.xhr?
      redirect_to '/staff'
    else
      @from_profile = true
      render :template => 'involvements/create'
    end
  end
  
  # A staff is defined as a anyone with a StaffRole.  But what really matters
  # is what their role gives them permission to do.
  # Staff are admin if they're marked admin in the ministry involvement.  The
  # actual role of being an admin doesn't inherently grant anything.
  def edit
    if params[:from_manage] == 'true'
      @ministry_involvement = @person.ministry_involvements.find params[:id]
      render :template => 'involvements/edit'
    elsif params[:person_id].present? && params[:ministry_id].present?
      @ministry_involvement = MinistryInvolvement.find(:first, :conditions => {:ministry_id => params[:ministry_id], :person_id => params[:person_id], :end_date => nil})
      unless @ministry_involvement
        flash[:notice] = "Couldn't find ministry involvement."
        redirect_to :back unless request.xhr?
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
    params[:ministry_involvement][:admin] = @ministry_involvement.admin? if @ministry_involvement.person == @me || !is_ministry_admin(@ministry, @me)
    
    # And you can't set any roles higher than yourself
    unless possible_roles.collect(&:id).include?(params[:ministry_involvement][:ministry_role_id].to_i)
      flash[:notice] = "Sorry, you can't set that role"
      return
    end
    @person = @ministry_involvement.person 

    @history = @ministry_involvement.update_ministry_role_and_history(params[:ministry_involvement][:ministry_role_id])

    # special case when editing a single person's role
    if params[:single_edit]
      flash[:notice] = "#{@person.full_name}'s ministry role updated to #{@ministry_involvement.ministry_role.name}"
    end
    @from_profile = params[:from_profile]
    respond_to do |wants|
      wants.js {
        render :template => 'involvements/update' if params[:from_manage] == 'true'
      }
    end
  end

  def edit_multiple_roles
    if params[:search_by_ministry_ids] && params[:person]
      people_ids = Array.wrap(params[:person]).collect{|person_id| person_id}

      if params[:search_by_ministry_role_ids]
        @involvements = MinistryInvolvement.all(:include => [:person],
                                                :order => "#{Person.table_name}.#{Person._(:first_name)} ASC, #{Person.table_name}.#{Person._(:last_name)} ASC",
                                                :conditions => ["#{MinistryInvolvement.table_name}.#{MinistryInvolvement._(:person_id)} IN (?) AND
                                                                 #{MinistryInvolvement.table_name}.#{MinistryInvolvement._(:ministry_id)} IN (?) AND

                                                                 #{MinistryInvolvement._(:ministry_role_id)} IN (?) AND

                                                                 #{MinistryInvolvement.table_name}.#{MinistryInvolvement._(:ministry_id)} NOT IN (1,2) AND
                                                                 #{MinistryInvolvement.table_name}.#{MinistryInvolvement._(:end_date)} IS NULL",
                                                                 people_ids, params[:search_by_ministry_ids], params[:search_by_ministry_role_ids]])
                                                             
      else
        @involvements = MinistryInvolvement.all(:include => [:person],
                                                :order => "#{Person.table_name}.#{Person._(:first_name)} ASC, #{Person.table_name}.#{Person._(:last_name)} ASC",
                                                :conditions => ["#{MinistryInvolvement.table_name}.#{MinistryInvolvement._(:person_id)} IN (?) AND
                                                                 #{MinistryInvolvement.table_name}.#{MinistryInvolvement._(:ministry_id)} IN (?) AND
                                                                 #{MinistryInvolvement.table_name}.#{MinistryInvolvement._(:ministry_id)} NOT IN (1,2) AND
                                                                 #{MinistryInvolvement.table_name}.#{MinistryInvolvement._(:end_date)} IS NULL",
                                                                 people_ids, params[:search_by_ministry_ids]])
      end

      involvement_ids = @involvements.collect{|involvement| involvement.id}

      @people = Person.all(:conditions => ["#{Person._(:id)} IN (?)", involvement_ids])
    end
  end

  def update_multiple_roles
    unless params[:role][:id] && params[:involvement_id]
      flash[:notice] = "Could not update roles, no particular roles or people were specified."
      return
    end
    unless possible_roles.collect(&:id).include?(params[:role][:id].to_i)
      flash[:notice] = "Sorry, you can't set that role."
      return
    end

    new_role = MinistryRole.first(:conditions => {:id => params[:role][:id].to_i})
    if new_role.present?
      people_notice = ""

      involvement_ids = Array.wrap(params[:involvement_id]).collect{|involvement_id| involvement_id}

      involvement_ids.each do |involvement_id|
        mi = MinistryInvolvement.first(:conditions => {:id => involvement_id})

        if @me.has_permission_to_update_role(mi, new_role)

          # current role is type staff but demoting to student
          if mi.ministry_role.class == StaffRole && new_role.class == StudentRole
            mi.demote_staff_to_student(new_role.id)

          # current role is type student but promoting to staff
          elsif mi.ministry_role.class == StudentRole && new_role.class == StaffRole
            mi.promote_student_to_staff(new_role.id)

          # current role type is the same as new role type
          else
            mi.update_ministry_role_and_history(new_role.id) unless new_role.id == mi.ministry_role.id
          end

          mi = MinistryInvolvement.first(:conditions => {:id => involvement_id}) # get final min involvement status to accurately display to user
          people_notice += "<img src='/images/silk/accept.png' style='vertical-align:middle;'> #{mi.person.full_name} is now a #{mi.ministry_role.name} at #{mi.ministry.name}<br/>"

        else
          # failed to get permission to update this person
          mi = MinistryInvolvement.first(:conditions => {:id => involvement_id}) # get final min involvement status to accurately display to user
          people_notice += "<img src='/images/silk/exclamation.png' style='vertical-align:middle;'> <b> #{mi.person.full_name} is currently a #{mi.ministry_role.name} at #{mi.ministry.name}, you can't set them to #{new_role.name} </b><br/>"
        end
      end

      flash[:notice] = "<big><b> Updated the following people's roles: </b></big> <br/> <br/> #{people_notice}"
    end

    redirect_to :action => "directory", :controller => "people"
  end

  
  protected

  def set_inv_type
    @plural = 'ministries'
    @singular = 'ministry'
    @short = 'mi'
    @add_title = 'Add Ministry / Team'
  end

  def set_ministries_and_roles
    @ministries = get_ministry.self_plus_descendants
    @roles = [ [ 'Staff Roles', StaffRole.all(:order => :position).collect{ |sr| [ sr.name, sr.id ] } ] ]
    @roles += [ [ 'Student Roles', StudentRole.all(:order => :position).collect{ |sr| [ sr.name, sr.id ] } ] ] unless is_staff_somewhere(@person) || params[:staff_roles_only] == 'true'
    @default_role_id = MinistryRole.default_staff_role.id
  end

end
