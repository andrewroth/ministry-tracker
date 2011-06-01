class CampusInvolvementsController < ApplicationController
  before_filter :set_campuses
  before_filter :set_school_years
  before_filter :set_inv_type
  before_filter :set_roles, :only => [ :new, :edit ]
  before_filter :set_student, :only => [ :index, :new, :edit ]
  
  skip_standard_login_stack :only => [:graduated]

  def index
    @campus_involvements = @person.campus_involvements
    @involvement_history = @person.involvement_history
    @from_profile = true
    render :template => 'involvements/index'
  end

  def new
    @campus_involvement = @person.campus_involvements.new :start_date => Date.today
    render :template => 'involvements/new'
  end

  def create
    # look for an existing one
    @campus_involvement = @person.all_campus_involvements.find :first, :conditions => { :campus_id => params[:campus_involvement][:campus_id] }
    @campus_involvement ||= @person.all_campus_involvements.new :start_date => Date.today, :ministry_id => get_ministry.id, :campus_id => params[:campus_involvement][:campus_id]
    @updated = !@campus_involvement.new_record?

    params[:campus_involvement][:school_year_id] = params[:campus_involvement][:school_year_id]
    update_campus_involvement
    if @campus_involvement.archived?
      @campus_involvement.end_date = nil
      @campus_involvement.last_history_update_date = Date.today
      @campus_involvement.save!
      @updated = false
    end

    @from_profile = true
    render :template => 'involvements/create'
  end

  def destroy
    @campus_involvement = CampusInvolvement.find(params[:id])
    destroy_campus_involvement
    respond_to do |format|
      format.xml  { head :ok }
      format.js { render :template => 'involvements/destroy' if params[:from_profile] == 'true' }
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
    @ministry_involvement = @campus_involvement.find_or_create_ministry_involvement
    render :template => 'involvements/edit'
  end
  
  def edit_school_year
    @campus_involvement = @person.campus_involvements.find params[:id]
    @campus_involvement.school_year_id = params[:school_year_id] if params[:school_year_id]
  end
  
  def graduated # intended to be used from a user code
    @user = User.find session[:code_valid_for_user_id]
    self.current_user = @user
    @me = @my = @person = @user.person
    
    graduated_school_year = SchoolYear.first(:conditions => ["#{SchoolYear._(:name)} = 'Graduated'"])
    
    if @my.primary_campus_involvement && @my.primary_campus_involvement.school_year != graduated_school_year
      campus_involvement_id = @my.primary_campus_involvement.id
      redirect_to edit_school_year_path(@my.id, campus_involvement_id, :school_year_id => SchoolYear.first(:conditions => ["#{SchoolYear._(:name)} = 'Graduated'"]).id)
      
    elsif @my.all_campus_involvements.blank?
      redirect_to set_initial_campus_person_url(@my.id)
      
    else
      campus_involvement_id = @my.primary_campus_involvement.try(:id)
      flash[:notice] = "<big>It looks like you've already graduated, but thanks anyways!</big>"
      flash[:notice] += "<br/><br/>If that's wrong <a href='#{edit_school_year_path(@my.id, campus_involvement_id)}'>click here to update your school year</a>." if campus_involvement_id
      
      redirect_to person_path @my.id
    end
  end
  
  def update
    @campus_involvement = @person.campus_involvements.find params[:id]
    update_campus_involvement
    @campus_involvement = @person.campus_involvements.find params[:id] # it may have changed, e.g. person graduated
    
    respond_to do |format|
      format.html {
        msg = "Thanks, your school year has been saved."
        msg += " Congrats on your graduation!" if @campus_involvement.school_year.name == "Graduated"
        flash[:notice] = "<big>#{msg}</big>"
        redirect_to person_path @campus_involvement.person_id
      }
      format.js { render :template => 'involvements/update' }
    end
  end

  def update_campus_involvement
    handle_campus_involvement do |is_student|
      if is_student
        update_student_campus_involvement
      else
        update_staff_campus_involvement
      end
    end
  end

  def destroy_campus_involvement
    handle_campus_involvement do |is_student|
      if is_student
        @history = @campus_involvement.new_student_history
        @history.save!
        @campus_involvement.last_history_update_date = Date.today
      end
      @campus_involvement.end_date = Date.today
      @campus_involvement.save(false)
    end
  end

  def handle_campus_involvement
    set_student
    yield @student
  end

  protected
  
  
  def update_staff_campus_involvement
    record_history = @campus_involvement.school_year_id != params[:school_year_id]
    @campus_involvement.update_attributes :school_year_id => params[:campus_involvement][:school_year_id],
      :campus_id => params[:campus_involvement][:campus_id]
  end

  # record the mi history as well
  def update_student_campus_involvement
    # TODO: this has been refactored into CampusInvolvement#update_student_campus_involvement. 
    # However, in the intereste of not breaking things, I'll leave it how it is here until I
    # have time to move it and test it thoroughly. -AR June 24, 2010
    #
    
    @student = true
    @campus_ministry_involvement = @campus_involvement.find_or_create_ministry_involvement
    
    # restrict students to making ministry involvements of their role or less
    if ministry_role_being_updated = (params[:ministry_involvement] && mr_id = params[:ministry_involvement][:ministry_role_id])
      
      requested_role = MinistryRole.find params[:ministry_involvement][:ministry_role_id]
      requested_role ||= MinistryRole.default_student_role
      
      # note that get_my_role sets @ministry_involvement as a side effect
      if !(get_my_role.is_a?(StaffRole) && requested_role.is_a?(StudentRole)) && requested_role.position < get_my_role.position
        
        flash[:notice] = "You can only set ministry roles of less than or equal to your current role"
        ministry_role_being_updated = false
        params[:ministry_involvement][:ministry_role_id] = @campus_ministry_involvement.ministry_role_id.to_s
      end
    end


    # record history
    record_history = !@campus_involvement.new_record? && 
      (@campus_involvement.school_year_id.to_s != params[:campus_involvement][:school_year_id] || 
      @campus_ministry_involvement.ministry_role_id.to_s != params[:ministry_involvement][:ministry_role_id] || 
      @campus_involvement.campus_id.to_s != params[:campus_involvement][:campus_id])
    if record_history
      @history = @campus_involvement.new_student_history
      @history.ministry_role_id = @campus_ministry_involvement.ministry_role_id
    end

    
    # update the records
    
    graduated_school_year = SchoolYear.first(:conditions => ["#{SchoolYear._(:name)} = 'Graduated'"])
    if params[:campus_involvement][:school_year_id].to_i == graduated_school_year.id
      # they are graduating
      # instead of updating the campus involvement directly we'll update their ministry involvement
      # this will in turn set all of their campus involvements to 'Graduated'
      
      ministry_role_being_updated = false # don't update it again later
      
      alumni_ministry_role = MinistryRole.first(:conditions => {:name => "Alumni"})
      @campus_ministry_involvement.ministry_role = alumni_ministry_role
      @campus_ministry_involvement.save!
    else
      @campus_involvement.update_attributes :school_year_id => params[:campus_involvement][:school_year_id]
    end
    @campus_involvement.update_attributes :campus_id => params[:campus_involvement][:campus_id]

    if ministry_role_being_updated
      @campus_ministry_involvement.ministry_role = requested_role
      @campus_ministry_involvement.save!
    end
    
    if record_history && @campus_involvement.errors.empty? && @campus_ministry_involvement.errors.empty?
      @history.save!
      @campus_involvement.update_attributes :last_history_update_date => Date.today
    end
    
    unless @campus_involvement.errors.empty?
      set_roles
    end
  end

  def set_campuses
    if Cmt::CONFIG[:campus_scope_country]
      @campuses = CmtGeo.campuses_for_country(CmtGeo.lookup_country_code(Cmt::CONFIG[:campus_scope_country]))
    else
      # TODO this should do the proper ajax choose Country -> State -> Campus
      @campuses = @person.ministries.collect &:campuses
      @campuses.flatten!
      @campuses.uniq!
    end
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

  def set_roles
    if !is_staff_somewhere(@me)
      student_roles = StudentRole.find(:all, :conditions => [ "position >= ?", get_my_role.position ])
    else
      student_roles = StudentRole.all
    end
    @roles = [ [ 'Student Roles', student_roles.collect{ |sr| [ sr.name, sr.id ] } ] ]
    @default_role_id = MinistryRole.default_student_role.id
  end

  def set_student
    @staff = @person.is_staff_somewhere?(false) # disable hrdb check in this case
    @student = !@staff
  end

end
