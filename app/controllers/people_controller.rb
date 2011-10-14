#require 'person_methods'
require 'csv'

# Question: Seems to handle the production of a directory view, either for
# entire campus (or ministry?), or according to search criteria. Does other things?
#
#Question: what is the difference between method new and method create?
#
#Question: What is the difference between a person and a user?
#
#Question: What is the use of primary_campus_id and its implications?
#
class PeopleController < ApplicationController
  include PersonMethodsEmu
  include PersonForm
  include SemesterSet

  before_filter :get_profile_person, :only => [:edit, :update, :show, :show_group_involvements, :set_label, :remove_label, :show_gcx_profile]
  before_filter :set_use_address2
  before_filter  :advanced_search_permission, :only => [:directory]
  before_filter :set_current_and_next_semester
  free_actions = [:set_current_address_states, :set_permanent_address_states,  
                  :get_campus_states, :set_initial_campus, :get_campuses_for_state,
                  :set_initial_ministry, :edit_me]
  skip_standard_login_stack :only => free_actions
     
  MENTOR_ID_NONE = nil
  
  
  #  AUTHORIZE_FOR_OWNER_ACTIONS = [:edit, :update, :show, :import_gcx_profile, :getcampuses,
  #                                 :get_campus_states, :set_current_address_states,
  #                                 :set_permanent_address_states]
  #  before_filter :authorization_filter, :except => AUTHORIZE_FOR_OWNER_ACTIONS
  #  before_filter :authorization_allowed_for_owner, :only => AUTHORIZE_FOR_OWNER_ACTIONS

  # GET /people
  # GET /people.xml
  def index
  end
  
  def impersonate
    if !session[:impersonator].present? && (Cmt::CONFIG[:allow_impersonate] || is_admin?)
      person = Person.find(params[:id])
      if person.user
        clear_session
        session[:impersonator] = current_user.id
        session[:user] = person.user.id
        @current_user = person.user
        redirect_to :back
      else
        flash[:notice] = "No user for person #{params[:id]}"
        redirect_to :back
      end
    end
  end
  
  # sets label (i.e. "Spiritual Multiplier") for a person and then redirects to the "show" action
  def set_label
    if params[:label]
      # begin
        
        @label = Label.find params[:label]
        
        unless @person.labels.include?(@label)
      		# @label_person = LabelPerson.create(:label_id => params[:label], :person_id => params[:id])
      		@person.labels << @label
      	else
      		# potentially could put LabelPerson.destroy( //ids of all records found for person-label combo)
      		# could follow up with same record create code
      	  
          @error_notice = "The '#{@label.content}' label has already been applied to #{@person.full_name}"
      	end
	        
      # rescue ActiveRecord::ActiveRecordError
      # rescue ActiveRecord::RecordNotFound
      #   # DO NOTHING
      # end      	
    end
    
    #redirect_back(:action => 'show', :id => params[:id], :error_notice => @error_notice)
  end
  
     # GET /people/remove_label
  # Removes a label that was previously assigned to the person
  def remove_label
    
    label_record = LabelPerson.find_by_label_id_and_person_id(params[:label_id],params[:person_id])
    label_record.destroy
    label_record.save
    render :nothing => true
  end
  

  def discipleship
    @p_user = @person
    @semester = @current_semester
    @person = Person.find(params[:id])    # needed so that current Pulse user is not used
  end
  
  
 # provides INITIAL display of summary profile info for mentee in partial beside discipleship tree
 def show_mentee_summary
   
   mentee = nil
   begin
       mentee = Person.find(params[:mentee_id])     
   rescue ActiveRecord::RecordNotFound 
    # DO NOTHING IF NO PERSON FOUND FOR MENTEE ID
    # TODO?: post a temporary flash notice (although this error should not ever happen)
    end  
  
    if (is_ministry_leader == true || mentee.campus == @person.campus)
      render :partial => "mentee_summary", :locals => { :mentee => mentee, :semester => @current_semester }
    else
      render :partial => "mentee_summary_not_permitted", :locals => { :mentee => mentee}
    end
    
  end
  
  # used for subsequent displays of mentee summary profile info (as above), as accessed by tree-links
  def show_mentee_profile_summary
    begin
      
      @selected_mentee = Person.find(params[:mentee_id])     
      
      if (is_ministry_leader == true || @selected_mentee.campus == @person.campus)
      	@mentee_page_to_display = "mentee_summary"
      else
      	@mentee_page_to_display = "mentee_summary_not_permitted"
      end          
      
      @person = Person.find(params[:mentor_id])    # needed so that current Pulse user is not used
      @bracket_level = params[:y]
      @is_first_level = params[:is_first_level]
      @name_height = params[:name_height]

      respond_to do |format|
        format.js
      end     
        
    rescue ActiveRecord::RecordNotFound 
    # DO NOTHING IF NO PERSON FOUND FOR MENTEE ID
    # TODO?: post a temporary flash notice (although this error should not ever happen)
    end  
 
  end
 

  def advanced
    get_campuses
    get_ministries
    @advanced = true
    @options = {}
    render :layout => 'application'
  end
  
  # Presents a list of all people matching the provided search criteria.
  # Capable of outputting as xml, xls, or html
  #
  # TODO: Needs some major re-writing! Far too large for one method.
  # Abstract into multiple methods, if not for repeatability,
  # at least for readability!
  #
  # Sets up pagination for results (TODO: this can be put in a method!)
  def directory
    get_view
    #my_campuses if get_ministry_involvement(current_ministry).ministry_role.is_a?(StudentRole)
    get_ministries
    get_campuses
    
    @advanced = true # we're now using advanced search by default
    @options = {}
    
    if params[:page].present?
      session[:last_options].each_pair do |k,v|
        next if k == :page || k == "page"
        params[k] = v  
      end
    end

    do_directory_search if @search_params_present = search_params_present? || params[:force] == 'true' || params[:page]

    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xls  do
        filename = @search_for.present? ? @search_for.gsub(';',' -') + ".xls" : "pulse_directory_search.xls"

        #this is required if you want this to work with IE        
        if request.env['HTTP_USER_AGENT'] =~ /msie/i
          headers['Pragma'] = 'public'
          headers["Content-type"] = "text/plain" 
          headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
          headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
          headers['Expires'] = "0" 
        else
          headers["Content-Type"] ||= 'text/xml'
          headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
        end
        render :action => 'excel', :layout => false
      end
      format.xml  { render :xml => @people.to_xml }
      format.csv do
        do_directory_search
        @people = ActiveRecord::Base.connection.select_all(@sql)
        fn = "tmp/#{Time.now.to_i}"
        csv_string = FasterCSV.open(fn, "w") do |csv|
          csv << @view.columns.collect(&:title)
          for person in @people
            csv << @view.columns.collect do |column|
              value = case column.column_type
                      when 'date'
                        format_date(person[column.safe_name])
                      when 'gender'
                        @person.human_gender(person[column.safe_name])
                      else
                        person[column.safe_name] 
                      end

            end
          end
        end

        #this is required if you want this to work with IE        
=begin
        if request.env['HTTP_USER_AGENT'] =~ /msie/i
          headers['Pragma'] = 'public'
          headers["Content-type"] = "text/plain" 
          headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
          headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
          headers['Expires'] = "0" 
        else
          headers["Content-Type"] ||= 'text/xml'
          headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
        end
=end

        user_fn = @search_for.gsub(';',' -') + ".csv"    
        send_file fn, :filename => user_fn, :type => "text/csv"
      end
    end
  end

  
  # Executes a search according to provided criteria.
  # Guesses if the entry includes a first and last name, splits them out for the search
  # TODO: Check it can handle two word lastnames like mine "Andrew de Jonge"

  def search
    # figure out if the search parameter looks like a first or last name only, or both
    @search = params[:search]
    if @search && !@search.empty?
      names = @search.strip.split(' ')
      conditions = [[],[]]
      if (names.size > 1)
        first = names[0].to_s
        last = names[1].to_s
        conditions[0] << "#{_(:last_name, :person)} LIKE ? AND #{_(:first_name, :person)} LIKE ? "
        conditions[1] << last + "%"
        conditions[1] << first + "%"
      else
        name = names.join
        conditions[0] << "(#{_(:last_name, :person)} LIKE ? OR #{_(:first_name, :person)} LIKE ?) "
        conditions[1] << name+'%'
        conditions[1] << name+'%' 
      end
      if params[:filter_ids].present?
        conditions[0] << "#{Person.table_name}.#{_(:id, :person)} NOT IN(?)"
        conditions[1] << params[:filter_ids]
      end

      # Scope by the user's ministry / campus involvements
      involvement_condition = "("
      unless @person.is_staff_somewhere?
        involvement_condition += "#{CampusInvolvement.table_name}.#{_(:campus_id, :campus_involvement)} IN(?) OR " 
        conditions[1] << get_campus_ids
      else
      end
      involvement_condition += "#{MinistryInvolvement.table_name}.#{_(:ministry_id, :ministry_involvement)} IN(?) )" 

      conditions[0] << involvement_condition
      conditions[1] << current_ministry.self_plus_descendants.collect(&:id)

      @conditions = [ conditions[0].join(' AND ') ] + conditions[1]

      includes = [:current_address, :campus_involvements, :ministry_involvements]
      @people = Person.find(:all, :order => "#{_(:last_name, :person)}, #{_(:first_name, :person)}", :conditions => @conditions, :include => includes)
      respond_to do |format|
        if params[:context]
          format.js {render :partial => params[:context] + '/results', :locals => {:people => @people, :type => params[:type], :group_id => params[:group_id]}}
        else
          format.js {render :action => 'results'}
        end
      end
    else
      render :nothing => true
    end
  end
  
 
   # GET /people/remove_mentor
  # Updates a person's mentor via a person_id parameter  
  def remove_mentor
    # We don't actually delete people, just set the 'mentor_id' to 0
    #@person = Person.find(params[:id], :include => [:mentor_id])
    
    person = Person.find(params[:id]) # for some reason @person is always the Pulse user
    person.person_mentor_id = MENTOR_ID_NONE
    person.save
    render :partial => "mentor_search_box", :locals => { :person => person, :q => @q }
  end
  
  
  # GET /people/remove_mentee
  # Removes a person's mentee via a person_id parameter  
  def remove_mentee
    # We don't actually delete people, just find the person_id FOR THE MENTEE
    # then set the 'mentor_id' to 0
    person = Person.find(params[:id])   # find MENTEE
    person.person_mentor_id = MENTOR_ID_NONE
    person.save
    render :nothing => true
    #render :partial => "mentor_search_box", :locals => { :person => person, :q => @q }
  end

  # GET /people/show
  # Shows a person's profile (address info, assignments, involvements, etc)
  def show
    if @person.nil?
      flash[:notice] = "No person found with the requested id."
      redirect_to :controller => "dashboard"
    else
      # set the primary campus involvement if there are campus involvements
      if !@person.primary_campus_involvement && @person.campus_involvements.present?
        @person.primary_campus_involvement = @person.campus_involvements.last
        @person.save!
      end
      
      # check GET parameters generated from mentor auto-complete search; set new mentor if ID found
      profile_person = Person.find(params[:id]) # for some reason @person is always the Pulse user
      if ((authorized?(:add_mentor, :people)&&(profile_person == @me)) || authorized?(:add_mentor_to_other, :people))
        if params[:m]
          begin
            mentor_id = params[:m].to_i
            person_exists_check = Person.find(mentor_id)         
            if mentor_id.is_a?(Numeric) # & mentor_id != MENTOR_ID_NONE
              @person.person_mentor_id = params[:m];
              @person.save
            end
          rescue ActiveRecord::ActiveRecordError  #NOTE: this code should *never* get to execute because of "mentor exists?" check in SQL (search_controller)
            if person != nil
              flash[:notice] = "<b>WARNING:</b> " + person_exists_check.full_name + " already exists somewhere in the mentorship tree that " + @person.full_name + " is a part of!"
            else
              flash[:notice] = "<b>WARNING:</b> The person you tried to add as a mentor already exists somewhere in the mentorship tree that " + @person.full_name + " is a part of!"
            end
            show_error_notice = true;	#mentorship_cycle_error = true   # redirect to dashboard where notice will provide more information
            
          rescue ActiveRecord::RecordNotFound
            # DO NOTHING
          end        
        end     
      end
      
       # check GET parameters generated from mentee auto-complete search; set new mentee if ID found
      if ((authorized?(:add_mentee, :people)&&(profile_person == @me)) || authorized?(:add_mentee_to_other, :people))
        if params[:mt]
          show_error_notice = false 	#mentorship_cycle_error = false
          begin
            mentee_id = params[:mt].to_i
            if mentee_id.is_a?(Numeric) # & mentor_id != MENTOR_ID_NONE
              person = Person.find(params[:mt])
              person.person_mentor_id = @person.id
              person.save 
            end   
          rescue ActiveRecord::ActiveRecordError
            if person != nil
              flash[:notice] = "<b>WARNING:</b> " + person.full_name + " already exists somewhere in the mentorship tree that " + @person.full_name + " is a part of!"
            else
              flash[:notice] = "<b>WARNING:</b> The person you tried to add as a mentee already exists somewhere in the mentorship tree that " + @person.full_name + " is a part of!"
            end
            show_error_notice = true	#mentorship_cycle_error = true   # redirect to dashboard where notice will provide more information
          rescue ActiveRecord::RecordNotFound 
            # DO NOTHING  

          end     
        end
      end
      
      get_ministry_involvement(get_ministry)
      get_people_responsible_for
      setup_vars
      
     if (show_error_notice == true)
        set_notices   # make sure error notice is displayed
        respond_to do |format|
          format.html { render :action => :show }# show.rhtml
          format.xml  { render :xml => @person.to_xml }
        end
      else
        respond_to do |format|
          format.html { render :action => :show }# show.rhtml
          format.xml  { render :xml => @person.to_xml }
        end
      end
    end
  end
  
  def me
    params[:id] = @person.id
    @person = current_user.person
    show
  end
  
  def edit_me # intended to be used with a user code
    unless session[:code_valid_for_user_id] # just to be sure
      access_denied(true)
      return
    end
    
    @user = User.find session[:code_valid_for_user_id]
    self.current_user = @user
    @me = @my = @person = @user.person
    session[:edit_profile] = true
    
    redirect_to :action => :show, :id => @my.id
  end
  
  def setup_new
    @person = Person.new
    @current_address = CurrentAddress.new
    @countries = CmtGeo.all_countries
    @states = CmtGeo.all_states
    @modal = request.xhr?
  end

  # GET /people/new
  def new
    setup_new
    set_dorms
    respond_to do |format|
      format.html { render :template => 'people/new', :layout => 'manage' }# new.rhtml
      format.js
    end
  end

  # GET /people/1/edit
  def edit
    countries = get_countries
    
    current_address_states = get_states @person.current_address.try(:country)
    permanent_address_states = get_states @person.permanent_address.try(:country)
    current_address_country = @person.current_address.try(:country)
    permanent_address_country = @person.permanent_address.try(:country)
    @person.sanify_addresses

    #get_possible_responsible_people
    setup_vars
    setup_campuses
    render :update do |page|
      thickbox = Cmt::CONFIG[:person_edit_in_thickbox]
      page[:info].hide unless thickbox
      page[:edit_info].replace_html :partial => 'edit',
        :locals => {
          :current_address_country => current_address_country,
          :permanent_address_country => permanent_address_country,
          :countries => countries,
          :current_address_states => current_address_states,
          :permanent_address_states => permanent_address_states }
      page[:edit_info].show
      page << "show_dialog('Edit Group', 700, 550)" if thickbox
    end
  end

    
  def destroy
    # We don't actually delete people, just set an end date on whatever ministries and campuses they are involved in under this user's permission tree
    @person = Person.find(params[:id], :include => [:ministry_involvements, :campus_involvements])
    ministry_involvements_to_end = @person.ministry_involvements.collect &:id
    MinistryInvolvement.update_all("#{_(:end_date, :ministry_involvement)} = '#{Time.now.to_s(:db)}'",
                                   "#{_(:id, :ministry_involvement)} IN(#{ministry_involvements_to_end.join(',')})") unless ministry_involvements_to_end.empty?
    
    campus_involvements_to_end = @person.campus_involvements.collect &:id
    CampusInvolvement.update_all("#{_(:end_date, :campus_involvement)} = '#{Time.now.to_s(:db)}'",
                                 "#{_(:id, :campus_involvement)} IN(#{campus_involvements_to_end.join(',')})") unless campus_involvements_to_end.empty?

    group_involvements_to_end = @person.all_group_involvements.destroy_all
    
    flash[:notice] = "#{@person.full_name}'s involvements on the Pulse have successfully been removed"
    
    if (params[:logout] == 'true')
      redirect_to logout_url
    else
      redirect_to :back
    end
  end
  # POST /people
  # POST /people.xml
  def create
    @modal = request.xhr?
    @person = Person.new(params[:person])
    @current_address = CurrentAddress.new(params[:current_address]) 
    @permanent_address = PermanentAddress.new(params[:perm_address]) 
    @countries = CmtGeo.all_countries
    @states = CmtGeo.all_states
    
    
    respond_to do |format|
      
      can_assign_role = true if @my.role(@ministry) && @my.role(@ministry).compare_class_and_position(MinistryRole.find(params[:ministry_involvement][:ministry_role_id])) >= 0
      
      # If we don't have a valid person and valid address, get out now
      if @person.valid? && @current_address.valid? && @permanent_address.valid? && can_assign_role
        
        @person, @current_address = add_person(@person, @current_address, params)
        @person.permanent_address.update_attributes(params[:perm_address])
        
        # if we don't have a good username, Raise an error
        # Since we require a unique email address, we should never get here. 
        unless @person.user 
          raise "Duplicate email address error. Couldn't create a user for:" + @person.inspect
        end
        
        if @ministry
          ministry_role = MinistryRole.find params[:ministry_involvement][:ministry_role_id]
          @staff_role = ministry_role.is_a?(StaffRole)
          @student_role = ministry_role.is_a?(StudentRole)

          # add the person to this ministry if they aren't already
          if @student_role
            @ci = @person.add_or_update_campus params[:campus_involvement][:campus_id], 
              params[:campus_involvement][:school_year_id],
              @ministry.id,
              @me

            # If this is an Involved Student record that has plain_password value, 
            # this is a new user who should be notified of the account creation
#            if @person.user.plain_password.present? && is_involved_somewhere(@person)
#              UserMailer.deliver_created_student(@person, @ministry, @me, @person.user.plain_password)
#            end
          end

          # create ministry involvement if it doesn't already exist
          @mi = @person.add_or_update_ministry(@ministry.id, params[:ministry_involvement][:ministry_role_id])
        end
        
        # The person MUST have a user record
        if @person.user && @person.user.save && (@staff_role || (@ci && @ci.valid?)) && @mi.valid?
          @success = true
          format.html { redirect_to person_path(@person) }
          format.js
          format.xml  { head :created, :location => person_path(@person) }
        else
          @user = @person.user
          render_new_from_create(format)
        end
      else
        flash[:notice] = "Sorry, you can't assign that role to a new student." unless can_assign_role
        render_new_from_create(format)
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    countries = get_countries
    get_people_responsible_for
    get_possible_responsible_people if Cmt::CONFIG[:rp_system_enabled]
    get_ministry_involvement(get_ministry)
    @person = Person.find(params[:id])
    if params[:responsible_person_id]
      #pulls values to needed for most_recent_ministry_involvement to be uses
      @most_recent_campus_involvement = @person.most_recent_involvement
      @most_recent_ministry = @most_recent_campus_involvement.ministry
      @most_recent_ministry_involvement = @person.ministry_involvements.find_by_ministry_id @most_recent_ministry.id
      
      @most_recent_ministry_involvement.responsible_person = Person.find(params[:responsible_person_id])
      @most_recent_ministry_involvement.save
    end
    if params[:current_address]
      @person.current_address ||= CurrentAddress.new(:email => params[:current_address][:email])
      @person.current_address.update_attributes(params[:current_address])
    end
    if params[:perm_address]
      @person.permanent_address ||= PermanentAddress.new(:email => params[:perm_address][:email]) 
      @person.permanent_address.update_attributes(params[:perm_address]) 
    end

    current_address_states = get_states @person.current_address.try(:country)
    permanent_address_states = get_states @person.permanent_address.try(:country)
    current_address_country = @person.current_address.try(:country) || default_country
    permanent_address_country = @person.permanent_address.try(:country) || default_country

    if params[:user] && @person.user
      @person.user.update_attributes(params[:user])
    end
    
    setup_vars

    respond_to do |format|
      if @person.update_attributes(params[:person]) && 
          (params[:current_address].nil? || @current_address.valid?) &&
          (params[:perm_address].nil? || @perm_address.valid?)
        
        if params[:primary_campus_involvement].present? &&  @person.most_recent_involvement
          @person.most_recent_involvement.update_attributes(params[:primary_campus_involvement])
        end
         
        # Save custom attributes
        @ministry.custom_attributes.each do |ca|
          @person.set_value(ca.id, params[ca.safe_name]) if params[ca.safe_name]
        end
        # Save training questions
        @ministry.training_questions.each do |q|
          @person.set_training_answer(q.id, params[q.safe_name + '_date'], params[q.safe_name + 'approver']) if params[q.safe_name + '_date']
        end
        
        if params[:set_campus_requested] == 'true'
          flash[:notice] += "  You can now <A HREF='#{join_groups_url}'>Join a Group</A>."
        end

        @person = Person.find(params[:id])
        format.html { redirect_to person_path(@person) }
        format.js do 
          render :update do |page|
            update_flash(page, flash[:notice])
            unless params[:no_profile]
              page[:info].replace_html :partial => 'view'
              page[:info].show
              page[:edit_info].hide
              if @update_involvements
                page[:campuses_div].replace_html :partial => 'campuses'
              end
              page << "$.scrollTo(0, 0)"
              if Cmt::CONFIG[:person_edit_in_thickbox]
                page['dialog'].hide
                page.call("close_thickbox")
              end
            end
          end
        end
        format.xml  { head :ok }
      else
        set_dorms
        setup_campuses
        # @person.errors.add_to_base('Please select a primary campus.') if params[:primary_campus_id].blank?
        format.html { render :action => "edit" }
        format.js do 
          render :update do |page|
            page[:edit_info].replace_html :partial => 'edit',
              :locals => {
                :current_address_country => current_address_country,
                :permanent_address_country => permanent_address_country,
                :countries => countries,
                :current_address_states => current_address_states,
                :permanent_address_states => permanent_address_states }
            page << "$.scrollTo(0, 0)"
          end
        end
        format.xml  { render :xml => @person.errors.to_xml }
      end
    end
  end
  
  def set_initial_ministry
    get_person
  end

  def set_initial_campus
    return unless login_required
    get_person

    if request.method == :put

      @person.first_name = params[:person][:first_name]
      @person.last_name = params[:person][:last_name]
      @person.gender = params[:person][:gender]
      @person.local_phone = params[:person][:local_phone]
      @person.errors.add_on_blank([:first_name, :last_name, :local_phone])
      @person.errors.add(:gender, :blank) if params['person']['gender'].blank?

      @primary_campus_involvement = CampusInvolvement.new params[:primary_campus_involvement]
      @primary_campus_involvement.errors.add_on_blank([:campus_id, :school_year_id])

      unless @person.errors.present? || @primary_campus_involvement.errors.present?
        @person.save!

        ministry_campus = MinistryCampus.find(:last, :conditions => { :campus_id => params[:primary_campus_involvement][:campus_id] })
        if ministry_campus
          ministry = ministry_campus.ministry
        else
          ministry = Ministry.default_ministry
          throw "add some ministries" unless ministry
        end
        @primary_campus_involvement = CampusInvolvement.create params[:primary_campus_involvement].merge(:person_id => @person.id, :ministry_id => ministry.id)
        @primary_campus_involvement.find_or_create_ministry_involvement
      end
    end

    # assume they are not staff at all
    @is_staff_somewhere ||= {}

    setup_campuses

    # attempt to render hte template manually here, because of some crash emails
    # suggesting on a get request, the .js.rjs is rendered.  Not sure why, could be
    # based on browser, or passenger
    if request.method == :get
      render :template => "people/set_initial_campus.html.erb"
    end
  end

  # Change which ministry we are now viewing in our session
  # NOTE: there is security checking done in ApplicationController::get_ministry
  def change_ministry_and_goto_directory
    session[:ministry_id] = params[:current_ministry].to_i
    @ministry = nil; get_ministry # reset the active ministry
    
    respond_to do |wants|
      wants.html { redirect_to(directory_people_path(:campus => params[:campus], :format => :html)) }
      wants.js do
        render :update do |page|
          page.redirect_to(directory_people_path(:campus => params[:campus], :format => :html))
        end
      end
    end
  end
  
  # Question: what does it do? Are there customisable views, and this changes
  # the currently used one? Yes - see the directory
  def change_view
    session[:user_changed_view] = true
    session[:view_id] = params[:view]
    # Clear session[:order] since this view might not have the same columns
    session[:order_column_id] = nil
    respond_to do |wants|
      wants.html { redirect_to(directory_people_path(:format => :html)) }
      wants.js do
        render :update do |page|
          page.redirect_to(directory_people_path(:format => :html))
        end
      end
    end
  end
    
  # Renders the add person form but restricts role to students; also assumes an ajax
  # form render.
  def add_student
    setup_new
    @force_student = true
    respond_to do |format|
      format.js  do
        render :update do |page|
          page[:dialog].replace(:partial => 'students/ajax_form', :locals => {:person => Person.new})
        end
      end
    end
  end
  
  def import_gcx_profile
    proxy_granting_ticket = session[:cas_pgt]
    unless proxy_granting_ticket.nil?
      begin
        success = @person.import_gcx_profile(proxy_granting_ticket)
        if success
          flash[:notice] = "Your GCX Profile has been imported successfully." 
        else
          flash[:warning] = "There was a problem importing your GCX Profile. Please try again later." 
        end
      rescue Errno::ETIMEDOUT
        flash[:warning] = "There was a problem importing your GCX Profile. Please try again later."
      end
    else
      flash[:warning] = "There was a problem importing your GCX Profile. Please try again later."
    end
    redirect_to @person
  end
  
  # For RJS call for dynamic population of state dropdown (see edit method)
  def set_current_address_states
    @current_address_states = CmtGeo.states_for_country(params[:current_address_country]) || []
  end
  
  # For RJS call for dynamic population of state dropdown (see edit method)
  def set_permanent_address_states
    @permanent_address_states = CmtGeo.states_for_country(params[:perm_address_country]) || []
  end

  def show_group_involvements
    @semester = Semester.find(params[:semester_id].to_i)

    respond_to do |format|
      format.js
    end
  end
  
  
  def show_gcx_profile
    if !@person.user || !@person.user.guid || !@person.user.guid.present?
      flash[:notice] = "#{@person.first_name} doesn't have a GUID, they might not have a GCX profile"
      redirect_to @person
      return
    end
    
    begin
      request_url = construct_cas_proxy_authenticated_service_url(gcx_profile_report_config[:url], {:guid => @person.try(:user).try(:guid)})
      
      @gcx_unauthenticated = true unless request_url.include?("ticket=")
      
      agent = Mechanize.new
      Rails.logger.info "\tGCX profile report service call (#{Date.today}) #{request_url}"
      page = agent.get(request_url)
      
      @hpricot = Hpricot(page.body)
    rescue => e
      error_message = "\nERROR WITH GCX PROFILE RESPONSE: \n\t#{e.class.to_s}\n\t#{e.message}\n"
      error_message += "\t#{request_url}\n" if request_url
      Rails.logger.error(error_message)
      flash[:notice] = "There was a problem retrieving #{@person.first_name}'s GCX profile" unless @gcx_unauthenticated
    end
  end
  
  
  
  
  private

    def do_directory_search
      @having = []
      if params[:search_id]
        @search = @my.searches.find(params[:search_id])
        @conditions = @search.query
        conditions = @conditions.split(' AND ')
        @options = JSON::Parser.new(@search.options).parse
        tables_with_string_keys = JSON::Parser.new(@search.tables).parse
        @tables = {}
        tables_with_string_keys.each_pair do |k,v|
          @tables[k.constantize] = v
        end
        @search_for = @search.description
        @search.update_attribute(:updated_at, Time.now)
        @advanced = true if @tables.present?
      else
        # Build conditions
        conditions = []  #["#{first_name_col} <> ''"]
        search = params[:search].to_s.strip
        # search = '%' if search.empty?
        case true
        when !search.scan(' ').empty?
          names = search.split(' ')
          first = names[0].strip
          last = names[1].strip
          conditions << "#{Person._(:last_name)} LIKE '#{quote_string(last)}%' AND #{Person._(:first_name)} LIKE '#{quote_string(first)}%'"
        when !search.scan('@').empty?
          conditions << search_email_conditions(search)
        else
          if search.present?
            conditions << "(#{Person._(:last_name)} LIKE '#{quote_string(search)}%' OR #{Person._(:first_name)} LIKE '#{quote_string(search)}%')"
          end
        end

      
        # Advanced search options
        @options = {}
        @tables = {}
        @search_for = []
        
        # Check year in school
        if params[:school_year].present?
          conditions << database_search_conditions(params)[:school_year]
          @tables[CampusInvolvement] = "Person.#{_(:id, :person)} = CampusInvolvement.#{_(:person_id, :campus_involvement)}"
          @search_for << SchoolYear.find(:all, :conditions => "#{_(:id, :school_year)} in(#{quote_string(params[:school_year].join(','))})").collect(&:description).join(', ')
          @advanced = true
          @searched_school_year_ids = params[:school_year]
        end
      
        # Check gender
        if params[:gender].present?
          conditions << database_search_conditions(params)[:gender]
          @search_for << params[:gender].collect {|gender| Person.human_gender(gender)}.join(', ')
          @advanced = true
        end
      
        if params[:first_name].present?
          conditions << "Person.#{_(:first_name, :person)} LIKE '#{quote_string(params[:first_name])}%'"
          @search_for << "First Name: #{params[:first_name]}"
          @advanced = true
        end
        
        if params[:last_name].present?
          conditions << "Person.#{_(:last_name, :person)} LIKE '#{quote_string(params[:last_name])}%'"
          @search_for << "Last Name: #{params[:last_name]}"
          @advanced = true
        end
        
        if params[:email].present?
          conditions << database_search_conditions(params)[:email]
          @search_for << "Email: #{params[:email]}"
          @advanced = true
        end

        if params[:role].present? && params[:role].first.to_i > 0
          conditions << database_search_conditions(params)[:role]
          @tables[MinistryInvolvement] = "Person.#{_(:id, :person)} = MinistryInvolvement.#{_(:person_id, :ministry_involvement)}"
          @search_for << MinistryRole.find(:all, :conditions => "#{_(:id, :ministry_role)} in(#{quote_string(params[:role].join(','))})").collect(&:name).join(', ')
          @advanced = true
          @searched_ministry_roles = params[:role]
        end

        conditions = add_involvement_conditions(conditions, nil)
      
        @options = params.dup.delete_if {|key, value| ['action','controller','commit','search','format'].include?(key)}
        session[:last_options] = @options
      
        @conditions = conditions.join(' AND ')
        @search_for = @search_for.empty? ? (params[:search] || 'Everyone') : @search_for.join("; ")
      end
      
      conditions = ""

      if !params[:group_involvement].present?
      elsif params[:group_involvement].include?("not_group")
        @search_for << ", Not in a group this semester"
        @having << "GroupInvolvements IS NULL"
      elsif params[:group_involvement].include?("in_group")
        @search_for << ", In a group this semester"
        @having << "GroupInvolvements IS NOT NULL"
      end

      for i in params[:group_involvement] || []
        next if i == 'in_group' || i == 'not_group'
        i = i.to_i

        group_type = GroupType.find(i < 0 ? -i : i)
        @semester = Semester.current
        conditions = "(#{get_ministry.descendants_condition}) AND semester_id = #{@semester.id} " + 
          " AND group_type_id = #{group_type.id}"
        @group_type_groups = Group.find(:all, :conditions => conditions, :joins => [ :ministry ])
        @group_ids = [ 0 ] + @group_type_groups.collect(&:id).collect(&:to_s)
        if i > 0
          @search_for << ", In a #{group_type.short_name} this semester"
          @having << "GroupInvolvements IS NOT NULL"
        elsif i < 0
          @search_for << ", Not in a #{group_type.short_name} this semester"
          @having << "GroupInvolvements IS NULL"
        end
      end

      if params[:group_involvement].present?
        @extra_select = "TempGroupInvolvement.group_involvements as GroupInvolvements"
        @group_ids ||= [ 0 ] + Semester.current.groups.collect(&:id)
=begin
        ActiveRecord::Base.connection.execute(%|LOCK TABLES #{TempGroupInvolvement.table_name} WRITE, #{Person.table_name} READ, #{GroupInvolvement.table_name} READ, 
                                              #{Search.table_name} WRITE, #{Person.table_name} as Person READ, #{Column.table_name} READ, #{ViewColumn.table_name} READ,
                                              #{CampusInvolvement.table_name} as CampusInvolvement READ, #{MinistryInvolvement.table_name} as MinistryInvolvement READ,
                                              #{CurrentAddress.table_name} as CurrentAddress READ, #{Access.table_name} as Access READ,
                                              #{Campus.table_name} as Campus READ, #{SchoolYear.table_name} as SchoolYear READ,
                                              #{Timetable.table_name} as Timetable READ, #{TempGroupInvolvement.table_name} as TempGroupInvolvement WRITE,
                                              mysql.time_zone_name READ
                                              |)
=end
        TempGroupInvolvement.delete_all
        sql = "INSERT INTO #{TempGroupInvolvement.table_name} SELECT #{Person.__(:person_id)} as person_id, 
            GROUP_CONCAT(#{GroupInvolvement._(:group_id)} SEPARATOR ',') as GroupInvolvements FROM #{Person.table_name} LEFT JOIN 
            #{GroupInvolvement.table_name} on #{Person.__(:person_id)} = #{GroupInvolvement.__(:person_id)} AND #{GroupInvolvement._(:group_id)} IN (#{@group_ids.join(',')}) 
            GROUP BY #{Person.__(:person_id)} ORDER BY #{Person.__(:person_id)}"
        ActiveRecord::Base.connection.execute(sql)
        @temp_group_involvements_locked = true
        Lock.establish_lock("not_in_group")
        @tables[TempGroupInvolvement] = "Person.person_id = TempGroupInvolvement.person_id"
      end

      new_tables = @tables.dup.delete_if {|key, value| @view.tables_clause.include?(key.to_s)}
      tables_clause = @view.tables_clause + new_tables.collect {|table| "LEFT JOIN #{table[0].table_name} as #{table[0].to_s} on #{table[1]}" }.join(' ')
      if params[:search_id].blank?
        @search = @my.searches.find(:first, :conditions => {_(:query, :search) => @conditions})
        if @search
          @search.update_attribute(:updated_at, Time.now)
        else
          @search = @my.searches.create(:options => @options.to_json, :query => @conditions, :tables => @tables.to_json, :description => @search_for)
        end
        # Only keep the last 5 searches
        @my.searches.last.destroy if @my.searches.length > 5
      end
      
      # If these conditions will result in too large a set, use pagination
      @group = Person._(:id)
      build_sql(tables_clause, @extra_select)
      @people = ActiveRecord::Base.connection.select_all(@sql).paginate(:page => params[:page])
      if @temp_group_involvements_locked
        Lock.free_lock("not_in_group")
      end
      @count = @people.total_entries

      # pass which ministries were searched for to the view
      if params[:ministry]
        ministries = Ministry.find :all, :conditions => "#{Ministry._(:id)} IN (#{params[:ministry].join(",")})"
        @searched_ministry_ids = ministries.collect{ |m| m.self_and_descendants }.flatten.uniq.collect(&:id).collect(&:to_s) & get_ministry_ids
      end
      @searched_ministry_ids ||= get_ministry_ids
      
      # pass which campuses were searched for to the view
      if params[:campus]
        campuses = Campus.find :all, :conditions => "#{Campus._(:id)} IN (#{params[:campus].join(",")})"
        @searched_campus_ids = campuses.uniq.collect(&:id).collect(&:to_s)
      end
    end

    
    def get_people_responsible_for
      @people_responsible_for = @person.people_responsible_for
    end

    def get_possible_responsible_people
      @possible_responsible_people = []
      
      # pull values we'll need, make sure this one exists
      @most_recent_campus_involvement = @person.most_recent_involvement
      return unless @most_recent_campus_involvement
      
      # continue pulling values, can't continue without both of these
      @most_recent_ministry = @most_recent_campus_involvement.ministry
      return unless @most_recent_ministry
      @most_recent_ministry_involvement = @person.ministry_involvements.find_by_ministry_id @most_recent_ministry.id
      return unless @most_recent_ministry_involvement
      
      # find my position
      persons_ministry_involvement_position = @most_recent_ministry_involvement.ministry_role.position
      
      # find everyone in this ministry with a higher access
      higher_mi_array = []
      @most_recent_ministry.ministry_involvements.each do |cur_mi|
        if cur_mi.ministry_role.position < persons_ministry_involvement_position && cur_mi.ministry_role.type == "StaffRole"
          higher_mi_array << cur_mi
        end
      end
      
      # only show people in your campus
      higher_mi_array.each do |h_mi|
        person = h_mi.person
        
        if person.campus_involvements.find_by_campus_id @most_recent_campus_involvement.campus.id
          @possible_responsible_people << person
        end
      end
    end
    
    def render_new_from_create(format)
      set_dorms
      format.html { render :action => "new", :layout => 'manage' }
      format.js  {render :action => 'new'}
      format.xml  { render :xml => @person.errors.to_xml }
    end
    
    def setup_vars
      set_dorms
      @profile_picture = @person.profile_picture || ProfilePicture.new
      @profile_picture.person_id = @person.id
      @current_address = @person.current_address || Address.new(_(:type, :address) => 'current')
      @perm_address = @person.permanent_address || Address.new(_(:type, :address) => 'permanent')
      #@show_ministries_list = get_ministry_involvement(get_ministry).try(:ministry_role).is_a?(StaffRole)
      @staff = is_staff_somewhere(@person)
      @student = !@staff
      @dorms = @person.primary_campus ? @person.primary_campus.dorms : []

      # we want to show two semesters into the future
      last_shown_semester = @current_semester
      2.times { last_shown_semester = last_shown_semester.next_semester unless last_shown_semester.next_semester.nil? }
      @semesters = Semester.find(:all, :conditions => ["#{_(:id, :semester)} <= ?", last_shown_semester.id])
    end
    
    def set_dorms
      @dorms = @person.primary_campus ? @person.primary_campus.dorms : []
    end
    
    def get_profile_person
      @person = Person.find(:first, :conditions => { Person._(:id) => params[:id] || session[:person_id]})
    end
   
    def get_view
      # first automatically change the view if the user has not chosen their own view
      if params[:view].blank? && session[:user_changed_view].blank? && params[:role].present?
        # change view to one that actually shows roles because we're searching by role
        session[:view_id] = View.first(:conditions => {:ministry_id => @ministry.id, :title => "Roles"}).id
        # Clear session[:order] since this view might not have the same columns
        session[:order_column_id] = nil
      end


      view_id = session[:view_id]
      if view_id
        @view = @ministry.views.find(:first, :conditions => _(:id, :view) + " = #{view_id}")
      end
      # If there's no view in the session, get the default view
      @view ||= @ministry.views.find(:first, :conditions => "default_view = 1", :include => {:view_columns => :column})
      unless @view
        # If there was no default view, set the first view found as the default
        @view = @ministry.views.find(:first)
        unless @view
          #If this ministry doesn't have any views, create the first view for this ministry
          @view = @ministry.create_first_view
        end
        @view.default_view = true
        @view.save!
      end
      session[:view_id] = @view.id
      @view
    end

    def build_sql(tables_clause = nil, extra_select = nil)
      setup_order_clause

      @sql =   'SELECT ' + @view.select_clause
      @sql += ', ' + extra_select if extra_select.present?
      tables_clause ||= @view.tables_clause
      @sql += ' FROM ' + tables_clause
      @sql += ' WHERE ' + @conditions
      @sql += ' GROUP BY ' + @group if @group
      @sql += ' HAVING ' + @having.join(" AND ") if @having.present?
      @sql += ' ORDER BY ' + @order
    end
  
    def setup_order_clause
      # setup a standard order to use for secondary sorting
      standard_order = 'Person.' + _(:last_name, :person) + ', ' +
        'Person.' + _(:first_name, :person)
      # update session
      session[:order_column_id] = params[:order_column_id] if params[:order_column_id]
      session[:direction] = params[:direction] if params[:direction]
      # generate the order clause
      order_column_id = session[:order_column_id]
      @order = ''
      if order_column_id
        column = @view.columns.find(:first, :conditions => [ "#{Column.__(:id)} = ?", order_column_id ]) || @view.columns.last
        @order += column.title.gsub(' ','_')
        @order += (params[:direction] == 'asc' ? ' ASC' : ' DESC')
        @order += ',' # get ready for appending standard order
      end
      @order += standard_order
    end

    def get_states(country)
      CmtGeo.states_for_country(country)
    end

    def set_use_address2
      @use_address2 = !Cmt::CONFIG[:disable_address2]
    end
    
    def get_campuses
      @campuses ||= @my.campus_list(get_ministry_involvement(@ministry), @ministry)
    end
    
    def get_campus_ids
      @campus_ids ||= get_campuses.collect(&:id).collect(&:to_s)
    end
    
    def get_ministries(ministry = nil)
      if is_staff_somewhere
        @ministries = get_ministry.self_and_descendants
      else
        @ministries = @my.ministries
      end
    end

    def get_ministry_ids
      @ministry_ids ||= get_ministries.collect(&:id).collect(&:to_s)
    end

    def add_involvement_conditions(conditions, only_null_ministry_involvement_end_date = true)
      if params[:ministry]
        ministries = Ministry.find :all, :conditions => "#{Ministry._(:id)} IN (#{params[:ministry].join(",")})"
        ministry_ids = ministries.collect{ |m| m.self_and_descendants }.flatten.uniq.collect(&:id).collect(&:to_s) & get_ministry_ids
        #ministry_ids = params[:ministry] & get_ministry_ids
        @advanced = true
      end
      ministry_ids ||= get_ministry_ids


      ministry_condition = "("
      ministry_condition += " MinistryInvolvement.#{_(:end_date, :ministry_involvement)} is NULL AND " if only_null_ministry_involvement_end_date
      ministry_condition += " MinistryInvolvement.#{_(:ministry_id, :ministry_involvement)} IN(#{quote_string(ministry_ids.join(','))}))"
      @tables[MinistryInvolvement] = "Person.#{_(:id, :person)} = MinistryInvolvement.#{_(:person_id, :ministry_involvement)}" if @tables

      # Check campus
      if params[:campus]
        # Only consider campus ids that this person is allowed to see (stop deviousness)
        if params[:campus].class == String
          params[:campus] = [ params[:campus] ]
        end
        campus_ids = params[:campus] & get_campus_ids
      end
      if !is_staff_somewhere
        campus_ids ||= get_campus_ids
      end

      if params[:campus] || !is_staff_somewhere
        if campus_ids.nil? || campus_ids.empty?
          campus_ids = [ 0 ] # so that the query doesn't crash
        end
        @search_for << Campus.find(:all, :conditions => "#{_(:id, :campus)} IN (#{quote_string(campus_ids.join(','))})").collect(&:name).join(', ')
        @tables[CampusInvolvement] = "Person.#{_(:id, :person)} = CampusInvolvement.#{_(:person_id, :campus_involvement)}" if @tables
        @advanced = true
        campus_condition = " (CampusInvolvement.#{_(:end_date, :campus_involvement)} is NULL"
        campus_condition += " AND CampusInvolvement.#{_(:campus_id, :campus_involvement)} IN (#{quote_string(campus_ids.join(','))}))"
      end


      # students should not have access to everyone in the ministry
      if is_staff_somewhere && campus_condition
        conditions << "(#{ministry_condition} AND #{campus_condition})"
      elsif is_staff_somewhere && !campus_condition
        conditions << "(#{ministry_condition})"
      elsif !is_staff_somewhere
        conditions << "(#{ministry_condition} AND #{campus_condition})"
      end

      return conditions
    end

    
    # does some post-processing on the people returned by directory.  I found this way
    # easier than getting the SQL right in some specific cases.  In particular, for people
    # with multiple campus involvements, the directory code is difficult to work with.
    # It auto adds a join on people and campus involvements.  It's really a pain to get
    # the campuses right in SQL, so it's done here.
    def post_process_directory(people)
      people_ids = {}
      people.reject!{ |person|
        if people_ids[person['person_id']]
          true
        else
          people_ids[person['person_id']] = true
          false
        end
      }

      if @not_group_type_groups.present?
        people.reject!{ |person|
          in_groups = person['GroupInvolvements'].to_s.split(',') & @not_group_type_groups_ids
          in_groups.present?
        }
      end

      if @check_no_group.present?
        people.reject!{ |person|
          person['GroupInvolvements'].to_s != ""
        }
      end
    end

    def search_params_present?
      if params[:search_id].present? ||
         params[:search].present? ||
         params[:school_year].present? ||
         params[:gender].present? ||
         params[:first_name].present? ||
         params[:last_name].present? ||
         params[:email].present? ||
         params[:role].present? ||
         params[:ministry].present? ||
         params[:group_involvement].present? ||
         params[:campus].present?

        return true
      else
        return false
      end
    end

    def advanced_search_permission
      unless authorized?(:advanced, :people)
        redirect_to :action => :index, :controller => :search
      end
    end
    
    
    # Utility Methods (from http://ethilien.net/archives/better-redirects-in-rails/)
    
    # redirect somewhere that will eventually return back to here
	def redirect_away(*params)
	  session[:original_uri] = request.request_uri
	  redirect_to(*params)
	end

	# returns the person to either the original url from a redirect_away or to a default url
	def redirect_back(*params)
	  uri = session[:original_uri]
	  session[:original_uri] = nil
	  if uri
	    redirect_to uri
	  else
	    redirect_to(*params)
	  end
	end

end
