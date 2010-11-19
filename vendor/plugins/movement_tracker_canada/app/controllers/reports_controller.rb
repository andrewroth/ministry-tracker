class ReportsController < ApplicationController
  unloadable
  skip_before_filter :authorization_filter, :only => [:select_report]

  def get_db_lines_from_report(report_name)
    stats_reports[report_name].sort { |a,b| a[1][:order] <=> b[1][:order]}.collect{|s| s[1][:column_type] == :database_column ? s : nil}.compact
  end

  def input_lines
    @input_lines ||= get_input_lines
    @input_lines
  end

  # necessary overide for ReportsController
  # gets the input lines for this report.
  def get_input_lines
    if @get_input_lines.nil?
      @get_input_lines = []
      input_reports.each do |ir|
        @get_input_lines.concat(get_db_lines_from_report(ir))
      end
    end
    @get_input_lines
  end

  # please override this function in any child class
  def input_reports
    []
  end
  
  # please override this function in any child class
  def identification_fields
    []
  end

  # please override this function in any child class
  def report_model
    nil
  end

  def get_params_name
    report_model.nil? ? '' : report_model.to_s.underscore
  end


  # GET /weekly_reports
  # GET /weekly_reports.xml
  def index
    @reports = report_model.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @weekly_reports }
    end
  end

  # GET /weekly_reports/1
  # GET /weekly_reports/1.xml
  def show
    @report = report_model.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report }
    end
  end

  def setup_dropdown_weeks
     @weeks ||= Week.all(:order => :week_endDate)
  end

  def setup_dropdown_months
     @months ||= Month.find(:all, :conditions => "(month_number <= #{ Time.now.month } AND month_calendaryear = #{ Time.now.year }) OR month_calendaryear <= #{ Time.now.year }", :order => "month_calendaryear, month_number")
  end

  def setup_dropdown_semesters
    @semesters = Semester.all(:order => :semester_startDate)
  end
  
  def setup_dropdown_years
    @years = Year.all()   # order by id, if that's not default
  end

  def setup_dropdown_campuses_with_new_report_permission
    unless @campuses
      unless is_ministry_admin
        @campuses = @my.campuses_under_my_ministries_with_children(::MinistryRole::ministry_roles_that_grant_access("#{report_model.to_s.pluralize.underscore}", "new"))
      else
        @campuses = Ministry.first.root.unique_campuses
      end
      @campuses.sort! {|a,b| a.name <=> b.name}
    end
    @campuses
  end

  def setup_report
    @id_fields = identification_fields
    input_lines
    identification_fields.each do |id_f|
      case id_f
        when :campus_id
          setup_dropdown_campuses_with_new_report_permission
        when :week_id
          setup_dropdown_weeks
        when :month_id
          setup_dropdown_months
        when :semester_id
          setup_dropdown_semesters
        when :year_id
          setup_dropdown_years
      end
    end
   
  end

  def get_current_staff_id
    @current_staff_id ||= @person.cim_hrdb_staff.id
  end

  def get_current_week_id
    @current_week_id ||= Week.find_week_id("#{Time.now.at_end_of_week.yesterday.year}-#{Time.now.at_end_of_week.yesterday.month}-#{Time.now.at_end_of_week.yesterday.day}")
  end

  def get_current_month_id
    @current_month_id ||= Month.find_month_id("#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}")
  end

  def get_current_semester_id
    @current_semester_id ||= Month.find_semester_id("#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}")
  end

  def get_current_campus_id
    unless @current_campus_id
      campus_found = nil
      campus_count = {}
      last_3_campuses = WeeklyReport.find(:all, :include => [:week], :conditions => {:staff_id => get_current_staff_id}, :limit => 3, :order => "#{Week.__(:end_date)} DESC").collect{|wr| wr[:campus_id]}
      last_3_campuses.each do |c|
        campus_count[c] ||= 0
        campus_count[c] += 1
      end

      last_3_campuses.each do |cf|
        campus_found = cf if campus_found.nil? || campus_count[cf] >= campus_count[campus_found]
      end
      @current_campus_id ||= campus_found

      # if person's most recently submitted stats are at a campus they no longer have involvements at
      if @current_campus_id.nil? || @my.ministries.index(Campus.find(@current_campus_id).derive_ministry).nil?
        @current_campus_id = setup_dropdown_campuses_with_new_report_permission.first.id
      end

    end
    @current_campus_id
  end

  def get_current_year_id
    unless @current_year_id
      now_year = Time.now.year()
      @current_year_id = Year.find_year_id("#{now_year} - #{now_year+1}")
    end
    @current_year_id
  end

  def setup_report_from_conditions(report, conditions)
    identification_fields.each { |id_f| report[id_f] = conditions[id_f] }
    report
  end

  def setup_conditions_for_new
    conditions = {}
    identification_fields.each do |id_f|
      case id_f
        when :staff_id
          conditions[:staff_id] = get_current_staff_id
        when :week_id
          conditions[:week_id] = get_current_week_id
        when :month_id
          conditions[:month_id] = get_current_month_id
        when :semester_id
          conditions[:semester_id] = get_current_semester_id
        when :year_id
          conditions[:year_id] = get_current_year_id
        when :campus_id
          conditions[:campus_id] = get_current_campus_id
      end
    end
    conditions
  end

  def setup_for_record(conditions)    
    @report = report_model.find(:first, :conditions => conditions)
    @report ||= create_report_from_conditions(conditions)
 
    setup_report
  end
  
  def create_report_from_conditions(conditions)
    report = report_model.new
    setup_report_from_conditions(report, conditions)
  end

  # GET /weekly_reports/new
  # GET /weekly_reports/new.xml
  def new
    
    setup_for_record(setup_conditions_for_new)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @weekly_report }
    end
  end

  # GET /weekly_reports/1/edit
  def edit
    @report = report_model.find(params[:id])

    setup_report
    
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @report }
    end
 
  end


  def setup_conditions_from_params(report_params)
    conditions = {}
    identification_fields.each do |id_f|
      case id_f
        when :staff_id
          conditions[:staff_id] = get_current_staff_id
        else
          conditions[id_f] = report_params[id_f]
      end
    end
    conditions
  end

  def url_to_redirect_after_update
    url_for(:controller => :stats, :action => :index)
  end

  def create_or_update()

    conditions = setup_conditions_from_params(params[get_params_name])
    @report = report_model.find(:first, :conditions => conditions)
    @report ||= create_report_from_conditions(conditions)

    success_update = false
    success_update = true if @report.update_attributes(params[get_params_name])
  
    respond_to do |format|
      if success_update
        @report.save!
        flash[:notice] = 'Your numbers were successfully submitted.'
        format.html { redirect_to(url_to_redirect_after_update) }
        format.xml  { head :ok }
      else
        setup_report
        
        format.html { render :action => "new" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /weekly_reports
  # POST /weekly_reports.xml
  def create
    create_or_update
  end

  # PUT /weekly_reports/1
  # PUT /weekly_reports/1.xml
  def update
    create_or_update
  end

  # DELETE /weekly_reports/1
  # DELETE /weekly_reports/1.xml
  def destroy
    @report = report_model.find(params[:id])
    @report.destroy

    unless @report.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete numbers because:"
      @report.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(weekly_reports_url) }
      format.xml  { head :ok }
    end
  end

  def select_report
    
    setup_for_record(setup_conditions_from_params(params))
  
    respond_to do |format|
      format.js
    end
  end




end