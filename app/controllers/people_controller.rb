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
  skip_before_filter    :get_ministry, :only => [:change_ministry]
  append_before_filter  :get_profile_person, :only => [:edit, :update, :show]
  append_before_filter  :can_edit_profile, :only => [:edit, :update]
  # GET /people
  # GET /people.xml
  def index
  end
  
  def directory
    # Get View
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
    
    # Build conditions
    first_name_col = _(:first_name, :person)
    last_name_col = _(:last_name, :person)
    email = _(:email, :address)
    conditions = ["#{first_name_col} <> ''"]
    search = params[:search].to_s.strip
    search = '%' if search.empty?
    case true
    when !search.scan(' ').empty?
      names = search.split(' ')
      first = names[0].strip
  		last = names[1].strip
    	conditions << "#{last_name_col} LIKE '#{quote_string(last)}%' AND #{first_name_col} LIKE '#{quote_string(first)}%'"
    when !search.scan('@').empty?
      conditions << "CurrentAddress.#{email} = '#{quote_string(search)}'"
    else
      conditions << "(#{last_name_col} LIKE '#{quote_string(search)}%' OR #{first_name_col} LIKE '#{quote_string(search)}%')"
    end
    if params[:campus_id]
      @campus = Campus.find(params[:campus_id])
    end
    conditions = add_involvement_conditions(conditions)
    @conditions = conditions.join(' AND ')
  
    # If these conditions will result in too large a set, use pagination
    @count = ActiveRecord::Base.connection.select_value("SELECT count(*) FROM #{@view.tables_clause} WHERE #{@conditions}").to_i
    if @count > 0
      # Build range for pagination
      if @count > 500
        finish = params[:finish]
        if (start = params[:start]).nil?
          start = ''
          if @count > 2000
            finish ||= 'am'
          else
            finish ||= 'b'
          end
        end
        if finish.to_s.empty?
          conditions << "#{last_name_col} >= '#{start}'"
        else
          conditions << "#{last_name_col} BETWEEN '#{start}' AND '#{finish}'"
        end
        @conditions = conditions.join(' AND ')
      end
      sql =   'SELECT ' + @view.select_clause 
      sql += ' FROM ' + @view.tables_clause
      sql += ' WHERE ' + @conditions
      sql += ' ORDER BY ' + _(:last_name, :person) + ', ' + _(:first_name, :person)
      @people = ActiveRecord::Base.connection.select_all(sql)
    else
      @people = []
      @count = 0
    end
    @sql = sql

    respond_to do |format|
      format.xml  { render :xml => @people.to_xml }
      format.xls  do
        filename = "Directory.xls"    

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
    respond_to do |format|
      format.html { render :template => '/people/new', :layout => 'manage' }# new.rhtml
      format.js
    end
  end

  # GET /people/1;edit
  def edit
    setup_vars
    render :update do |page|
      page[:info].hide
      page[:edit_info].replace_html :partial => 'edit'
      page[:edit_info].show
    end
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
    @current_address = CurrentAddress.new(params[:current_address])
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
    @person = Person.find(params[:id])
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
    @perm_address = @person.permanent_address
    @person.updated_by = 'MT'
    @person.updated_at = Time.now

    respond_to do |format|
      if @person.update_attributes(params[:person]) && 
         (params[:current_address].nil? || @current_address.valid?) &&
         (params[:perm_address].nil? || @perm_address.valid?)
        # Save custom attributes
        @ministry.custom_attributes.each do |ca|
          @person.set_value(ca.id, params[ca.safe_name]) if params[ca.safe_name]
        end
        # Save training questions
        @ministry.training_questions.each do |q|
          @person.set_training_answer(q.id, params[q.safe_name + '_date'], params[q.safe_name + 'approver']) if params[q.safe_name + '_date']
        end
        flash[:notice] = 'Profile was successfully updated.'
        format.html { redirect_to person_path(@person) }
        format.js do 
          render :update do |page|
            update_flash(page, flash[:notice])
            unless params[:no_profile]
              page[:info].replace_html :partial => 'view'
              page[:info].show
              page[:edit_info].hide
            end
          end
        end
        format.xml  { head :ok }
      else
        setup_dorms
        # @current_address = @person.current_address
        #       @perm_address = @person.permanent_address
        format.html { render :action => "edit" }
        format.js do 
          render :update do |page|
            page[:edit_info].replace_html :partial => 'edit'
          end
        end
        format.xml  { render :xml => @person.errors.to_xml }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  # def destroy
  #   @person = Person.find(params[:id])
  #   @person.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to directory_people_path }
  #     format.xml  { head :ok }
  #   end
  # end
  
  def change_ministry
    session[:ministry_id] = params[:ministry]
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
	   	conditions = add_involvement_conditions(conditions)
	   	@conditions = [ conditions[0].join(' AND ') ] + conditions[1]
  
      includes = [:current_address, :campus_involvements, :ministry_involvements]
	  	@people = Person.find(:all, :order => "#{_(:last_name, :person)}, #{_(:first_name, :person)}", :conditions => @conditions, :include => includes)
	  	respond_to do |format|
	  	  if params[:context]
	  	    format.js {render :partial => params[:context]+'/results', :locals => {:people => @people, :type => params[:type], :group_id => params[:group_id]}}
  	    else
  	      format.js {render :action => 'results'}
	      end
	  	end
	  else
	    raise params.inspect
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
        @person.import_gcx_profile(proxy_granting_ticket)
      rescue Errno::ETIMEDOUT
        flash[:warning] = "There was a problem importing your GCX Profile. Please try again later."
      end
    end
    redirect_to @person
  end
  protected
    def add_involvement_conditions(conditions)
      # figure out which campuses to query based on the campuses listed for the current ministry
      if  @campus
        campus_cond = "CampusInvolvement.#{_(:campus_id, :campus_involvement)} = #{@campus.id}"
        conditions << campus_cond
      else
        if @ministry.campus_ids.length > 0
          campus_cond = "CampusInvolvement.#{_(:campus_id, :campus_involvement)} IN (#{@ministry.campus_ids.join(',')})"
        end
        # restrict to just this ministry's tree
  #      campus_cond << CampusInvolvement.table_name + '.' +_(:ministry_id, :campus_involvement) + ' = ?'
  #      conditions[1] << @ministry.root.id
        # include staff from this ministry and sub_ministries
        ministry_ids = @ministry.all_ministries.collect {|m| m.id}.join(',')
        ministry_cond = 'MinistryInvolvement.' + _(:ministry_id, :ministry_involvement) + " IN (#{ministry_ids})"
        if campus_cond
          conditions << '( ' + campus_cond + ' OR ' + ministry_cond + ' )'
        else
          conditions << ministry_cond
        end
      end
      return conditions
    end
    
    def render_new_from_create(format)
      setup_dorms
      format.html { render :action => "new", :layout => 'manage' }
      format.js  {render :action => 'new'}
      format.xml  { render :xml => @person.errors.to_xml }
    end
    
    def setup_vars
      setup_dorms
      @profile_picture = @person.profile_picture || ProfilePicture.new(:person_id => @person.id)
      @current_address = @person.current_address || Address.new(_(:type, :address) => 'current')
      @perm_address = @person.permanent_address || Address.new(_(:type, :address) => 'permanent')
    end
    
    def setup_dorms
      @dorms = @person.campuses.collect(&:dorms).flatten
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
end
