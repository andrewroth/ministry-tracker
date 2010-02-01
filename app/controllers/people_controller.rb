require 'person_methods'

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
  include PersonMethods
  before_filter  :get_profile_person, :only => [:edit, :update, :show]
  before_filter  :set_use_address2
  free_actions = [:set_current_address_states, :set_permanent_address_states,  
                  :get_campus_states, :set_initial_campus, :get_campuses_for_state]
  skip_before_filter :authorization_filter, :only => free_actions
  skip_before_filter :force_campus_set, :only => free_actions
  
  #  AUTHORIZE_FOR_OWNER_ACTIONS = [:edit, :update, :show, :import_gcx_profile, :getcampuses,
  #                                 :get_campus_states, :set_current_address_states,
  #                                 :set_permanent_address_states]
  #  before_filter :authorization_filter, :except => AUTHORIZE_FOR_OWNER_ACTIONS
  #  before_filter :authorization_allowed_for_owner, :only => AUTHORIZE_FOR_OWNER_ACTIONS

  # GET /people
  # GET /people.xml
  def index
  end
  
  def advanced
    get_campuses
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
    first_name_col = "Person.#{_(:first_name, :person)}"
    last_name_col = "Person.#{_(:last_name, :person)}"
    email = _(:email, :address)
    
    if params[:search_id]
      @search = @my.searches.find(params[:search_id])
      @conditions = @search.query
      conditions = @conditions.split(' AND ')
      @options = JSON::Parser.new(@search.options).parse
      @tables = JSON::Parser.new(@search.tables).parse
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
      	conditions << "#{last_name_col} LIKE '#{quote_string(last)}%' AND #{first_name_col} LIKE '#{quote_string(first)}%'"
      when !search.scan('@').empty?
        conditions << search_email_conditions(search)
      else
        if search.present?
          conditions << "(#{last_name_col} LIKE '#{quote_string(search)}%' OR #{first_name_col} LIKE '#{quote_string(search)}%')"
        end
      end
    
      # Advanced search options
      @options = {}
      @tables = {}
      @search_for = []
      # Check year in school
      if params[:school_year].present?
        conditions << database_search_conditions(params)[:school_year]
        @tables[CampusInvolvement] = "#{Person.table_name}.#{_(:id, :person)} = CampusInvolvement.#{_(:person_id, :campus_involvement)}"
        @search_for << SchoolYear.find(:all, :conditions => "#{_(:id, :school_year)} in(#{quote_string(params[:school_year].join(','))})").collect(&:description).join(', ')
        @advanced = true
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
    
      conditions = add_involvement_conditions(conditions)
    
      @options = params.dup.delete_if {|key, value| ['action','controller','commit','search','format'].include?(key)}
    
      @conditions = conditions.join(' AND ')
      @search_for = @search_for.empty? ? (params[:search] || 'Everyone') : @search_for.join("; ")
    end
    
    new_tables = @tables.dup.delete_if {|key, value| @view.tables_clause.include?(key.to_s)}
    tables_clause = @view.tables_clause + new_tables.collect {|table| "LEFT JOIN #{table[0].table_name} as #{table[0].to_s} on #{table[1]}" }.join('')
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
    @count = ActiveRecord::Base.connection.select_value("SELECT count(distinct(Person.#{_(:id, :person)})) FROM #{tables_clause} WHERE #{@conditions}").to_i
    if @count > 0
      # Build range for pagination
      if @count > 500
        finish = params[:finish]
        if (start = params[:start]).blank?
          start = ''
          if @count > 2000
            finish ||= 'am'
          else
            finish ||= 'b'
          end
        end
        if finish.blank?
          conditions << "#{last_name_col} >= '#{start}'"          
        else
          conditions << "#{last_name_col} BETWEEN '#{start}' AND '#{finish}'"
        end
        @conditions = conditions.join(' AND ')
      end
      
      build_sql(tables_clause)
      @people = ActiveRecord::Base.connection.select_all(@sql)
    else
      @people = []
      @count = 0
    end
    
    respond_to do |format|
      format.html { render :layout => 'application' }
      format.xls  do
        filename = @search_for.gsub(';',' -') + ".xls"    

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
	   	  conditions[0] << "#{_(:id, :person)} NOT IN(?)"
	   	  conditions[1] << params[:filter_ids]
   	  end
   	  
   	  # Scope by the user's ministry / campus involvements
   	  involvement_condition = "("
   	  if my_campus_ids.present?
     	  involvement_condition += "#{CampusInvolvement.table_name}.#{_(:campus_id, :campus_involvement)} IN(?) OR " 
  	   	conditions[1] << my_campus_ids
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

  # GET /people/show
  # Shows a person's profile (address info, assignments, involvements, etc)
  def show
    get_ministry_involvement(get_ministry)
    get_people_responsible_for
    setup_vars
    respond_to do |format|
      format.html { render :action => :show }# show.rhtml
      format.xml  { render :xml => @person.to_xml }
    end
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

    get_possible_responsible_people if Cmt::CONFIG[:rp_system_enabled]
    setup_vars
    setup_campuses
    render :update do |page|
      page[:info].hide
      page[:edit_info].replace_html :partial => 'edit',
        :locals => {
          :current_address_country => current_address_country,
          :permanent_address_country => permanent_address_country,
          :countries => countries,
          :current_address_states => current_address_states,
          :permanent_address_states => permanent_address_states }
      page[:edit_info].show
    end
  end

    
  def destroy
    # We don't actually delete people, just set an end date on whatever ministries and campuses they are involved in under this user's permission tree
    @person = Person.find(params[:id], :include => [:ministry_involvements, :campus_involvements])
    ministry_involvements_to_end = @person.ministry_involvements.select {|mi| current_ministry.self_plus_descendants.collect(&:id).include?(mi.ministry_id)}.collect(&:id)
    MinistryInvolvement.update_all("#{_(:end_date, :ministry_involvement)} = '#{Time.now.to_s(:db)}'", "#{_(:id, :ministry_involvement)} IN(#{ministry_involvements_to_end.join(',')})") unless ministry_involvements_to_end.empty?
    
    campus_involvements_to_end = @person.campus_involvements.select {|ci| @my.campus_list(get_ministry_involvement(current_ministry)).collect(&:id).include?(ci.campus_id)}.collect(&:id)
    CampusInvolvement.update_all("#{_(:end_date, :campus_involvement)} = '#{Time.now.to_s(:db)}'", "#{_(:id, :campus_involvement)} IN(#{campus_involvements_to_end.join(',')})") unless campus_involvements_to_end.empty?
    flash[:notice] = "All of #{@person.full_name}'s involvements have been ended."
    redirect_to :back
  end
  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
    @current_address = CurrentAddress.new(params[:current_address]) 
    @countries = CmtGeo.all_countries
    @states = CmtGeo.all_states

    respond_to do |format|
      # If we don't have a valid person and valid address, get out now
      if @person.valid? && @current_address.valid?
        @person, @current_address = add_person(@person, @current_address, params)
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
            if @person.user.plain_password.present? && is_involved_somewhere(@person)
              UserMailer.deliver_created_student(@person, @ministry, @me, @person.user.plain_password)
            end
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
        flash[:notice] = 'Profile was successfully updated.'
        if params[:set_campus_requested] == 'true'
          flash[:notice] += "  Thank you for setting your campus.  You can now <A HREF='#{join_groups_url}'>Join a Group</A>."
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
  
  def set_initial_campus
    if request.method == :put
      ministry_campus = MinistryCampus.find(:last, :conditions => { :campus_id => params[:primary_campus_involvement][:campus_id] })
      if ministry_campus
        ministry = ministry_campus.ministry
      else
        ministry = Cmt::CONFIG[:default_ministry_name]
        ministry ||= Ministry.first
        throw "add some ministries" unless ministry
      end
      @campus_involvement = CampusInvolvement.create params[:primary_campus_involvement].merge(:person_id => @person.id, :ministry_id => ministry.id)
      @campus_involvement.find_or_create_ministry_involvement
    end

    # assume they are not staff at all
    @is_staff_somewhere ||= {}

    setup_campuses
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
  # the currently used one?
  def change_view
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
  
  def get_campuses_for_state
    @campus_state = params[:primary_campus_state]
    @campus_country = params[:primary_campus_country]
    render :text => '' unless @campus_state
    @campuses = CmtGeo.campuses_for_state(@campus_state, @campus_country) || []
  end

  def get_campus_states
    @campus_country = params[:primary_campus_country]
    render :text => '' unless @campus_country.present?
    @campus_states = CmtGeo.states_for_country(@campus_country) || []
  end

  # For RJS call for dynamic population of state dropdown (see edit method)
  def set_current_address_states
    @current_address_states = CmtGeo.states_for_country(params[:current_address_country]) || []
  end
  
  # For RJS call for dynamic population of state dropdown (see edit method)
  def set_permanent_address_states
    @permanent_address_states = CmtGeo.states_for_country(params[:perm_address_country]) || []
  end

  private
    
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
    end
    
    def set_dorms
      @dorms = @person.primary_campus ? @person.primary_campus.dorms : []
    end
    
    def get_profile_person
      @person = Person.find(params[:id] || session[:person_id])
    end
    
    def setup_campuses
      @primary_campus_involvement = @person.primary_campus_involvement || CampusInvolvement.new
      # If the Country is set in config, don't filter by states but get campuses from the country
      if Cmt::CONFIG[:campus_scope_country] && 
        (c = Country.find(:first, :conditions => { _(:country, :country) => Cmt::CONFIG[:campus_scope_country] }))
        @no_campus_scope = true
        @campus_country = c
        @campuses = CmtGeo.campuses_for_country(c.abbrev).sort{ |c1, c2| c1.name <=> c2.name }
      else
        if @person.try(:primary_campus).try(:state).present? && @person.primary_campus.try(:country).present?
          @campus_state = @person.primary_campus.state
          @campus_country = @person.primary_campus.country
        elsif @person.current_address.try(:state).present? && @person.current_address.try(:country).present?
          @campus_state = @person.current_address.state
          @campus_country = @person.current_address.country
        elsif @person.try(:permanent_address).try(:state).present? && @person.permanent_address.try(:country).present?
          @campus_state = @person.permanent_address.state
          @campus_country = @person.permanent_address.country
        end
        @campus_states = CmtGeo.states_for_country(@campus_country) || []
        @campuses = CmtGeo.campuses_for_state(@campus_state, @campus_country) || []
      end
      @campus_countries = CmtGeo.all_countries
    end
    
    def get_view
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
      @sql += ' FROM ' + @view.tables_clause
      @sql += ' WHERE ' + @conditions
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
        column = @view.columns.find(order_column_id)
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
    
    def my_campuses
      @my_campuses ||= @my.campus_list(get_ministry_involvement(@ministry))
    end
    
    def my_campus_ids
      @my_campus_ids ||= my_campuses.collect(&:id)
    end
    
    def get_campuses
      return @campuses if @campuses
      if is_staff_somewhere
        @campuses = get_ministries.collect(&:campuses).flatten
      else
        @campuses = my_campuses
      end
    end
    
    def get_ministries(ministry = nil)
      if !is_staff_somewhere
        @ministries = [ get_ministry ]
      elsif ministry # recursive case
        [ ministry ] + ministry.children.collect{ |m| get_ministries(m) }
      else
        @ministries = get_ministries(get_ministry).flatten
      end
    end

    def add_involvement_conditions(conditions)
      # figure out which campuses to query based on the campuses listed for the current ministry
      # Check ministry
      ministry_condition = ''
      if params[:ministry]
        # Only consider ministry ids that this person is involved in (for students)
        unless is_staff_somewhere
          params[:ministry] = params[:ministry].collect(&:to_i) & @my.ministry_involvements.collect(&:ministry_id)
        end
        unless params[:ministry].empty?
          ministry_condition = "MinistryInvolvement.#{_(:ministry_id, :ministry_involvement)} IN(#{quote_string(params[:ministry].join(','))}) AND MinistryInvolvement.#{_(:end_date, :ministry_involvement)} is NULL"
          @search_for << Ministry.find(:all, :conditions => "id in(#{quote_string(params[:ministry].join(','))})").collect(&:name).join(', ')
          @advanced = true 
        end
      else
        ministry_condition = "MinistryInvolvement.#{_(:ministry_id, :ministry_involvement)} IN(#{quote_string(current_ministry.self_plus_descendants.collect(&:id).join(','))}) AND MinistryInvolvement.#{_(:end_date, :ministry_involvement)} is NULL"
      end
      @tables[MinistryInvolvement] = "Person.#{_(:id, :person)} = MinistryInvolvement.#{_(:person_id, :ministry_involvement)}" if @tables
    
      # Check campus
      campus_condition = ''
      if params[:campus].present?
        # Only consider campus ids that this person is allowed to see (stop deviousness)
        params[:campus] = params[:campus].collect(&:to_i) & @campuses.collect(&:id)
        unless params[:campus].empty?
          conditions << "CampusInvolvement.#{_(:campus_id, :campus_involvement)} IN(#{quote_string(params[:campus].join(','))}) AND CampusInvolvement.#{_(:end_date, :campus_involvement)} is NULL AND MinistryInvolvement.#{_(:end_date, :campus_involvement)} is NULL" 
          @search_for << Campus.find(:all, :conditions => "#{_(:id, :campus)} in (#{quote_string(params[:campus].join(','))})").collect(&:name).join(', ')
          @tables[CampusInvolvement] = "#{Person.table_name}.#{_(:id, :person)} = CampusInvolvement.#{_(:person_id, :campus_involvement)}" if @tables
          @advanced = true
        end
      elsif !params[:ministry].present?
        campus_ids = @campuses.collect &:id # note that @campuses is restricted to campus involvements in this ministry if the person is a student (see get_campuses)
        campus_condition = "CampusInvolvement.#{_(:campus_id, :campus_involvement)} IN(#{quote_string(campus_ids.join(','))}) AND CampusInvolvement.#{_(:end_date, :campus_involvement)} is NULL AND MinistryInvolvement.#{_(:end_date, :campus_involvement)} is NULL" if campus_ids.present?
      end
      
      if campus_condition.present?
        # students should not have access to everyone in the ministry
        if is_staff_somewhere
          conditions << ('(' + ministry_condition + ' OR ' + campus_condition + ')')
        else
          conditions << campus_condition
        end
        @tables[CampusInvolvement] = "#{Person.table_name}.#{_(:id, :person)} = CampusInvolvement.#{_(:person_id, :campus_involvement)}" if @tables
      else
        conditions << ministry_condition
      end
      return conditions
    end
    
end
