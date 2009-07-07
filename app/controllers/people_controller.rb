# 
#  people_controller.rb
#  studentnetwork
#  
#  Created by Josh Starcher on 2007-08-26.
#  Copyright 2007 Ministry Hacks. All rights reserved.
# 
require 'person_methods'

class PeopleController < ApplicationController
  include PersonMethods
  append_before_filter  :get_profile_person, :only => [:edit, :update, :show]
  append_before_filter  :can_edit_profile, :only => [:edit, :update]
  append_before_filter  :set_use_address2
  
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
    @advanced = true
    @options = {}
    @campuses = @my.ministries.collect {|ministry| ministry.campuses.find(:all)}.flatten.uniq
    render :layout => 'application'
  end
  
  def directory
    get_view
    @campuses = @my.ministries.collect {|ministry| ministry.campuses.find(:all)}.flatten.uniq
    first_name_col = _(:first_name, :person)
    last_name_col = _(:last_name, :person)
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
        conditions << "CurrentAddress.#{_(:email, :address)} = '#{quote_string(search)}'"
      else
        if search.present?
          conditions << "(#{last_name_col} LIKE '#{quote_string(search)}%' OR #{first_name_col} LIKE '#{quote_string(search)}%')"
        end
      end
    
      if params[:campus_id]
        @campus = Campus.find(params[:campus_id])
      end
    
      # Advanced search options
      @options = {}
      @tables = {}
      @search_for = []
      # Check year in school
      if params[:school_year].present?
        conditions << "CampusInvolvement.#{_(:school_year_id, :campus_involvement)} IN(#{quote_string(params[:school_year].join(','))})"
        @tables[CampusInvolvement] = "#{Person.table_name}.#{_(:id, :person)} = CampusInvolvement.#{_(:person_id, :campus_involvement)}"
        @search_for << SchoolYear.find(:all, :conditions => "id in(#{quote_string(params[:school_year].join(','))})").collect(&:description).join(', ')
        @advanced = true
      end
    
      # Check gender
      if params[:gender].present?
        conditions << "Person.#{_(:gender, :person)} IN(#{quote_string(params[:gender].join(','))})"
        @search_for << params[:gender].collect {|gender| Person.human_gender(gender)}.join(', ')
        @advanced = true
      end
    
      # Check ministry
      if params[:ministry].present?
        # Only consider ministry ids that this person is involved in (stop deviousness)
        params[:ministry] = params[:ministry].collect(&:to_i) & @my.ministry_involvements.collect(&:ministry_id)
        unless params[:ministry].empty?
          cond = "MinistryInvolvement.#{_(:ministry_id, :ministry_involvement)} IN(#{quote_string(params[:ministry].join(','))})"
          if params[:campus].present?
            conditions <<  cond 
          else
            conditions << ('(' + cond + ' OR ' + campus_condition + ')')
          end
          @tables[MinistryInvolvement] = "#{Person.table_name}.#{_(:id, :person)} = MinistryInvolvement.#{_(:person_id, :ministry_involvement)}"
          @search_for << Ministry.find(:all, :conditions => "id in(#{quote_string(params[:ministry].join(','))})").collect(&:name).join(', ')
          @advanced = true
        end
      end
    
      # Check campus
      if params[:campus].present?
        # Only consider ministry ids that this person is involved in (stop deviousness)
        params[:campus] = params[:campus].collect(&:to_i) & @campuses.collect(&:id)
        unless params[:campus].empty?
          conditions << "CampusInvolvement.#{_(:campus_id, :campus_involvement)} IN(#{quote_string(params[:campus].join(','))})"
          @tables[CampusInvolvement] = "#{Person.table_name}.#{_(:id, :person)} = CampusInvolvement.#{_(:person_id, :campus_involvement)}"
          @search_for << Campus.find(:all, :conditions => "#{_(:id, :campus)} in(#{quote_string(params[:campus].join(','))})").collect(&:name).join(', ')
          @advanced = true
        end
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
        conditions << "CurrentAddress.#{_(:email, :address)} = '#{quote_string(params[:email])}'"
        @search_for << "Email: #{params[:email]}"
        @advanced = true
      end
    
    
      conditions = add_involvement_conditions(conditions) if params[:ministry].blank? && params[:campus].blank?
    
      @options = params.dup.delete_if {|key, value| ['action','controller','commit','search'].include?(key)}
    

      @conditions = conditions.join(' AND ')
      
      @search_for = @search_for.empty? ? (params[:search] || 'Everyone') : @search_for.join("; ")
    end
    
    new_tables = @tables.dup.delete_if {|key, value| @view.tables_clause.include?(key.to_s)}
    tables_clause = @view.tables_clause + new_tables.collect {|table| "LEFT JOIN #{table[0].table_name} as #{table[0].to_s} on #{table[1]}" }.join('')
    
    if params[:search_id].blank?
      @search = Search.find(:first, :conditions => {_(:query, :search) => @conditions})
      if @search
        @search.update_attribute(:updated_at, Time.now)
      else
        @search = Search.create(:person_id => @my.id, :options => @options.to_json, :query => @conditions, :tables => @tables.to_json, :description => @search_for)
      end
      # Only keep the last 5 searches
      @my.searches.last.destroy if @my.searches.length > 5
    end
    
    # If these conditions will result in too large a set, use pagination
    @count = ActiveRecord::Base.connection.select_value("SELECT count(*) FROM #{tables_clause} WHERE #{@conditions}").to_i
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
      format.xml  { render :xml => @people.to_xml }
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
      format.html { render :layout => 'application' }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    get_ministry_involvement(get_ministry)
    get_people_responsible_for
    setup_vars
    respond_to do |format|
      format.html { render :action => :show }# show.rhtml
      format.xml  { render :xml => @person.to_xml }
    end
  end
  
  # GET /people/new
  def new
    @person = Person.new
    @current_address = CurrentAddress.new
    @countries = Country.all
    @states = State.all
    respond_to do |format|
      format.html { render :template => '/people/new', :layout => 'manage' }# new.rhtml
      format.js
    end
  end

  # GET /people/1;edit
  def edit
    countries = get_countries
    
    current_address_states = get_states @person.current_address.try(:state).try(:country_id)
    permanent_address_states = get_states @person.permanent_address.try(:state).try(:country_id)
    current_address_country_id = @person.current_address.try(:state).try(:country_id)
    permanent_address_country_id = @person.permanent_address.try(:state).try(:country_id)

    get_possible_responsible_people
    setup_vars
    setup_campuses
    render :update do |page|
      page[:info].hide
      page[:edit_info].replace_html :partial => 'edit',
        :locals => {
          :current_address_country_id => current_address_country_id,
          :permanent_address_country_id => permanent_address_country_id,
          :countries => countries,
          :current_address_states => current_address_states,
          :permanent_address_states => permanent_address_states }
      page[:edit_info].show
    end
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
    @current_address = CurrentAddress.new(params[:current_address])
    @countries = Country.all
    @states = State.all
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
          # add the person to this ministry if they aren't already
          if params[:student]
            # create campus involvement if it doesn't already exist
            @ci = CampusInvolvement.find_by_campus_id_and_person_id(params[:campus], @person.id)
            # also create the ministry inovlvement if they don't already have it
            # @mi = MinistryInvolvement.find_by_ministry_id_and_person_id(@ministry.id, @person.id) 
            # @mi.destroy if @mi
            if @ci
              @msg = 'The person you\'re trying to add is already on this campus.'
            else
              @person.add_campus(params[:campus], @ministry.id, @me.id, params[:ministry_role_id])
              # If this is an Involved Student record that has plain_password value, this is a new user who should be notified of the account creation
              if @person.user.plain_password.present? && is_involved_somewhere(@person)
                UserMailer.send_later(:deliver_created_student, @person, @ministry, @me, @person.user.plain_password)
              end
            end
          else
            # create ministry involvement if it doesn't already exist
            @mi = MinistryInvolvement.find_by_ministry_id_and_person_id(@ministry.id, @person.id)
            if @mi
              @mi.update_attributes(params[:ministry_involvement])
            else
              @person.ministry_involvements << MinistryInvolvement.new(params[:ministry_involvement]) if params[:ministry_involvement]
            end
          end

          # If they tried to add a staff as a student, smack them around a little
          # if params[:student] && @mi
          #   flash[:warning] = "#{@person.full_name} is already on staff. You can't add #{@person.male? ? 'him' : 'her'} as a student."
          # else
          flash[:notice] = @msg || 'Person was successfully added to your ministry.'
          # end
        end
        
        # The person MUST have a user record
        if @person.user && @person.user.save
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

    current_address_states = get_states @person.current_address.try(:state).try(:country_id)
    permanent_address_states = get_states @person.permanent_address.try(:state).try(:country_id)
    current_address_country_id = @person.current_address.try(:state).try(:country_id)
    permanent_address_country_id = @person.permanent_address.try(:state).try(:country_id)
    
    get_people_responsible_for
    get_possible_responsible_people
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
    @current_address = @person.current_address
    if params[:perm_address]
      @person.permanent_address ||= PermanentAddress.new(:email => params[:perm_address][:email]) 
      @person.permanent_address.update_attributes(params[:perm_address]) 
    end
    if params[:user] && @person.user
      @person.user.update_attributes(params[:user])
    end
    if params[:primary_campus_id].present? && (@person.primary_campus_involvement.nil? || params[:primary_campus_id].to_i != @person.primary_campus.id)
      # if @person.primary_campus_involvement
      #   @person.primary_campus_involvement.update_attribute(:end_date, Time.now)
      #   
      #   # @person.update_attribute(:primary_campus_involvement_id, nil)
      # end
      if @campus_involvement = @person.campus_involvements.find(:first, :conditions => {_(:campus_id, :campus_involvement) => params[:primary_campus_id]})
        @campus_involvement.update_attribute(:end_date, nil)
        @person.primary_campus_involvement = @campus_involvement
      else
        params[:primary_campus_involvement][:campus_id] = params[:primary_campus_id]
        params[:primary_campus_involvement][:start_date] = Time.now
        params[:primary_campus_involvement][:added_by_id] = @my.id
        params[:primary_campus_involvement][:ministry_id] = @ministry.id
        params[:primary_campus_involvement][:person_id] = @person.id
        @person.primary_campus_involvement = CampusInvolvement.new(params[:primary_campus_involvement])
        @update_involvements = true
      end
    end
    if params[:primary_campus_id].blank?
      if @person.primary_campus_involvement
         @person.primary_campus_involvement.update_attribute(:end_date, Time.now)
         @person.update_attribute(:primary_campus_involvement_id, nil)
          @update_involvements = true
      end
    end
      
    @perm_address = @person.permanent_address

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
                :current_address_country_id => current_address_country_id,
                :permanent_address_country_id => permanent_address_country_id,
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
  
  def change_ministry
    session[:ministry_id] = params[:current_ministry]
    respond_to do |wants|
      wants.html { redirect_to(directory_people_path) }
      wants.js do
        render :update do |page|
          page.redirect_to(directory_people_path)
        end
      end
    end
  end
  
  def change_view
    session[:view_id] = params[:view]
    # Clear session[:order] since this view might not have the same columns
    session[:order] = nil
    respond_to do |wants|
      wants.html { redirect_to(directory_people_path) }
      wants.js do
        render :update do |page|
          page.redirect_to(directory_people_path)
        end
      end
    end
  end
  
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
	   	conditions = add_involvement_conditions(conditions)
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
    
  def add_student
    
    respond_to do |format|
      format.js  do
        render :update do |page|
          page[:addStudent].replace(:partial => 'students/ajax_form', :locals => {:person => Person.new})
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

  def get_campuses
    @campus_state = State.find :first, :conditions => 
      { _(:id, :state) => params[:primary_campus_state_id] }
    render :text => '' unless @campus_state
    @campuses = @campus_state.try(:campuses) || []
  end

  def get_campus_states
    @campus_country = Country.find :first, :conditions => 
      { _(:id, :campus) => params[:primary_campus_country_id] }
    render :text => '' unless @campus_country
    @campus_states = @campus_country.states
  end

  # For RJS call for dynamic population of state dropdown (see edit method)
  def set_current_address_states
    @current_address_states = get_states params[:current_address_country_id]
  end
  
  # For RJS call for dynamic population of state dropdown (see edit method)
  def set_permanent_address_states
    @permanent_address_states = get_states params[:permanent_address_country_id]
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
    
    def campus_condition
      "CampusInvolvement.#{_(:campus_id, :campus_involvement)} IN (#{@ministry.campus_ids.join(',')})"
    end
    
    def ministry_condition
      @ministry_ids ||= @my.ministry_involvements.collect(&:ministry_id).join(',')
      'MinistryInvolvement.' + _(:ministry_id, :ministry_involvement) + " IN (#{@ministry_ids})"
    end
    
    def add_involvement_conditions(conditions)
      # figure out which campuses to query based on the campuses listed for the current ministry
      if  @campus
        campus_cond = "CampusInvolvement.#{_(:campus_id, :campus_involvement)} = #{@campus.id}"
        conditions << campus_cond
      else
        if @ministry.campus_ids.length > 0
          conditions << '( ' + campus_condition + ' OR ' + ministry_condition + ' )'
        else
          conditions << ministry_condition
        end
      end
      return conditions
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
    end
    
    def set_dorms
      @dorms = @person.primary_campus ? @person.primary_campus.dorms : []
    end
    
    def can_edit_profile
      if @person == @me || is_ministry_leader
        return true
      else 
        respond_to do |wants|
          wants.html { redirect_to @person }
          wants.js  do
            render :update do |page|
              page.redirect_to(@person)
            end
          end
        end
        
        return false
      end
    end
    
    def get_profile_person
      @person = Person.find(params[:id] || session[:person_id])
    end
    
    def setup_campuses
      @primary_campus_involvement = @person.primary_campus_involvement || CampusInvolvement.new
      # If the Country is set in config, don't filter by states but get campuses from the country
      if Cmt::CONFIG[:campus_scope_country] && 
        (c = Country.find :first, :conditions => { _(:country, :country) => Cmt::CONFIG[:campus_scope_country] })
        @no_campus_scope = true
        @campus_country = c
        @campuses = @campus_country.states.collect{|s| s.campuses}.flatten
      else
        @campus_state = @person.primary_campus.try(:state) || 
          @person.current_address.try(:state) ||
          @person.permanent_address.try(:state)
        @campus_country = @campus_state.try(:country)
        @campus_states = @campus_country.try(:states) || []
        @campuses = @campus_state.try(:campuses) || []
      end
      @campus_countries = Country.all
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
      # Add order if it's available
      standard_order = _(:last_name, :person) + ', ' + _(:first_name, :person)
      session[:order] = params[:order] if params[:order]
      order = session[:order] 
      @order = order ? order + ',' + standard_order : standard_order
      
      @sql =   'SELECT ' + @view.select_clause 
      @sql += ', ' + extra_select if extra_select.present?
      tables_clause ||= @view.tables_clause
      @sql += ' FROM ' + @view.tables_clause
      @sql += ' WHERE ' + @conditions
      @sql += ' ORDER BY ' + @order
    end
  
    def get_states
      country = Country.find params[:primary_campus_country_id]
      @campus_states = country.try(:states) || []
    end

    def get_states(country_id)
      State.find_all_by_country_id(country_id)
    end

    def set_use_address2
      @use_address2 = !Cmt::CONFIG[:disable_address2]
    end
end
