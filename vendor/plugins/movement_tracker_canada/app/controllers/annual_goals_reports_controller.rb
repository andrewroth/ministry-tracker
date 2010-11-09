class AnnualGoalsReportsController < ReportsController
  unloadable

  def identification_fields
    [:year_id, :campus_id]
  end

  def report_model
    AnnualGoalsReport
  end

  def input_reports
    [:annual_goals_report]
  end
#
#  skip_before_filter :authorization_filter, :only => [:select_annual_goals_report]    
#    
#  # GET /annual_goals_reports
#  # GET /annual_goals_reports.xml
#  def index
#    @annual_goals_reports = AnnualGoalsReport.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @annual_goals_reports }
#    end
#  end
#
#  # GET /annual_goals_reports/1
#  # GET /annual_goals_reports/1.xml
#  def show
#    @annual_goals_report = AnnualGoalsReport.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @annual_goals_report }
#    end
#  end
#
#  def setup_for_record(year_id, campus_id)
#    @annual_goals_report = AnnualGoalsReport.find(:first, :conditions => { :year_id => year_id, :campus_id => campus_id })
#    @annual_goals_report ||= AnnualGoalsReport.new 
#
#    @annual_goals_report.year_id = year_id
#    @annual_goals_report.campus_id = campus_id
#    
#    @years = Year.all()   # order by id, if that's not default
#
#    unless is_ministry_admin
#      @campuses = @my.campuses_under_my_ministries_with_children(::MinistryRole::ministry_roles_that_grant_access("annual_goals_reports", "new"))
#    else
#      @campuses = Ministry.first.root.unique_campuses
#    end
#    @campuses.sort! {|a,b| a.name <=> b.name}
#
#  end
#
#  # GET /annual_goals_reports/new
#  # GET /annual_goals_reports/new.xml
#  def new
#  
#    now_year = Time.now.year()
#    current_year_id = Year.find_year_id("#{now_year} - #{now_year+1}")
#    current_campus_id = get_ministry.unique_campuses.first.id
#    
#    setup_for_record(current_year_id, current_campus_id)
#    
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @annual_goals_report }
#    end
#  end
#
#  # GET /annual_goals_reports/1/edit
#  def edit
#    @annual_goals_report = AnnualGoalsReport.find(params[:id])
#  end
#
#  def create_or_update
#    @annual_goals_report = AnnualGoalsReport.find(:first, :conditions => { :year_id => params[:annual_goals_report][:year_id], :campus_id => params[:annual_goals_report][:campus_id] })
#
#    if @annual_goals_report
#      @annual_goals_report.update_attributes(params[:annual_goals_report])
#      notice = 'Your goals were successfully re-submitted.'
#    else
#      @annual_goals_report = AnnualGoalsReport.new(params[:annual_goals_report])
#      notice = 'Your goals were successfully submitted.'
#    end
#
#    respond_to do |format|
#      if @annual_goals_report.save
#        flash[:notice] = notice
#        format.html { redirect_to(url_for(:controller => :stats, :action => :index)) }
#        format.xml  { render :xml => @annual_goals_report, :status => :created, :location => @annual_goals_report }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @annual_goals_report.errors, :status => :unprocessable_entity }
#      end
#    end
#    
#  end
#
#  # POST /annual_goals_reports
#  # POST /annual_goals_reports.xml
#  def create
#    create_or_update
#  end
#
#  # PUT /annual_goals_reports/1
#  # PUT /annual_goals_reports/1.xml
#  def update
#    create_or_update
#
##    @annual_goals_report = AnnualGoalsReport.find(:first, :conditions => { :year_id => params[:annual_goals_report][:year_id], :campus_id => params[:annual_goals_report][:campus_id] })
##
##    if @annual_goals_report
##      success_update = true if @annual_goals_report.update_attributes(params[:annual_goals_report])
##    else
##      success_update = true if @annual_goals_report = AnnualGoalsReport.new(params[:annual_goals_report])
##    end
##
##    respond_to do |format|
##      if success_update && @annual_goals_report.save
##        flash[:notice] = 'Your goals were successfully updated.'
##        format.html { redirect_to(url_for(:controller => :stats, :action => :index)) }
##        format.xml  { head :ok }
##      else
##        format.html { render :action => "edit" }
##        format.xml  { render :xml => @annual_goals_report.errors, :status => :unprocessable_entity }
##      end
##    end
#  end
#
#  # DELETE /annual_goals_reports/1
#  # DELETE /annual_goals_reports/1.xml
#  def destroy
#    @semester_report = AnnualGoalsReport.find(params[:id])
#    @semester_report.destroy
#
#    unless @semester_report.errors.empty?
#      flash[:notice] = "WARNING: Couldn't delete goals because:"
#      @semester_report.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
#    end
#
#    respond_to do |format|
#      format.html { redirect_to(annual_goals_reports_url) }
#      format.xml  { head :ok }
#    end
#  end
#
#  def select_annual_goals_report
#    setup_for_record(params['year_id'], params['campus_id'])
#  
#    respond_to do |format|
#      format.js
#    end
#  end

end

