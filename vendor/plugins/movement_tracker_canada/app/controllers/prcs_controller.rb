class PrcsController < ApplicationController
  unloadable

  skip_before_filter :authorization_filter, :only => [:refresh_prc_index]

  # GET /prcs
  # GET /prcs.xml
  def index
   
    setup_for_index(active_data(:semester_id), active_data(:campus_id))

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @prcs }
    end
  end

  # GET /prcs/1
  # GET /prcs/1.xml
  def show
    @prc = Prc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @prc }
    end
  end
  

  # GET /prcs/new
  # GET /prcs/new.xml
  def new
    @prc = Prc.new
          
    @prc.semester_id = active_data(:semester_id)
    @prc.campus_id = active_data(:campus_id)
    @prc.prc_date = default_date
    
    setup_campuses_and_semesters

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @prc }
    end
  end

  # GET /prcs/1/edit
  def edit
    @prc = Prc.find(params[:id])

    setup_campuses_and_semesters

    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @prc }
    end
  end
  
  # POST /prcs
  # POST /prcs.xml
  def create
    create_or_update
  end

  # PUT /prcs/1
  # PUT /prcs/1.xml
  def update
    create_or_update
  end

  # DELETE /prcs/1
  # DELETE /prcs/1.xml
  def destroy
    @prc = Prc.find(params[:id])
    @prc.destroy

    unless @prc.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete indicated decision report because:"
      @prc.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(prcs_url) }
      format.xml  { head :ok }
    end
  end
  

  def select_prc_report
    setup_for_record(params['semester_id'], params['campus_id'], params['date'])
  
    respond_to do |format|
      format.js
    end
  end
  
  def refresh_prc_index
    setup_for_index(params['semester_id'], params['campus_id'])
  
    respond_to do |format|
      format.js
    end
  end
  
  
  protected
  
  def create_or_update
    @prc = Prc.find(params[:prc][:id]) unless params[:prc][:id].nil? || params[:prc][:id] == ''
  
    if @prc
      success_update = true if @prc.update_attributes(params[:prc])
    else
      success_update = true if @prc = Prc.new(params[:prc])
    end
  
    respond_to do |format|
      if success_update
        @prc.save!
        set_active_data(:semester_id, @prc.semester_id)
        set_active_data(:campus_id, @prc.campus_id)
        flash[:notice] = 'Your indicated decision report was successfully submitted.'
        format.html { redirect_to(url_for(:controller => :prcs, :action => :index)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @prc.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def setup_campuses_and_semesters()
    @semesters = Semester.all(:order => :semester_startDate)  
    @campuses = user_campuses
    @methods = Prcmethod.all()
  end
  
  def setup_for_record(semester_id, campus_id, date)
    
    set_active_data(:semester_id, semester_id)
    set_active_data(:campus_id, campus_id)
    
    @prc = Prc.new
          
    @prc.semester_id = semester_id
    @prc.campus_id = campus_id
    @prc.prc_date = date
    
    setup_campuses_and_semesters
    
  end 
  
  def setup_for_index(semester_id, campus_id)
    set_active_data(:semester_id, semester_id)
    set_active_data(:campus_id, campus_id)
    
    @prcs = Prc.find_all_by_semester_id_and_campus_id(semester_id, campus_id)  
    if @prcs.empty?
      prc = Prc.new      
      prc.semester_id = active_data(:semester_id)
      prc.campus_id = active_data(:campus_id)
      @prcs = [prc]
      @no_prc = true
    else
      @no_prc = false
    end
    setup_campuses_and_semesters
  end  

  def user_campuses
    @user_campuses ||= @my.campuses_under_my_ministries_with_children(::MinistryRole::ministry_roles_that_grant_access("prcs", "new"))
  end

  #used to define default values
  def key_data
    @key_data ||= { :semester_id => current_semester_id, :campus_id => default_campus_id }
  end

  #set the context that the user has chosen
  def set_active_data(key, value)
    @active_data ||= {}
    @active_data[key] = value
    session[key] = value
  end

  #used to get the context the user has chosen
  def active_data(key)
    @active_data ||= {}
    unless @active_data[key]
      if session[key].present?
        @active_data[key] = session[key]
      else
        @active_data[key] = key_data[key]
        session[key] = @active_data[key]
      end
    end
    @active_data[key]
  end

  def active_semester
    @active_semester ||= Semester.find(active_data(:semester_id))
  end

  def default_date
    result = nil
    if Time.now <= active_semester.end_date && Time.now >= active_semester.start_date
      result = Date.today
    end
    result    
  end

  #default value for the semester_id
  def current_semester_id
    unless @current_semester_id
      cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
      @current_semester_id = Month.find_semester_id(cur_month)   
    end
    @current_semester_id
  end
  
  #default value for the campus_id
  def default_campus_id
    unless @default_campus_id || user_campuses.nil? || user_campuses.empty?
      @default_campus_id = user_campuses.first().id        
    end
    @default_campus_id
  end
  
end
