class WeeklyReportsController < ApplicationController
  unloadable

  # GET /weekly_reports
  # GET /weekly_reports.xml
  def index
    @weekly_reports = WeeklyReport.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @weekly_reports }
    end
  end

  # GET /weekly_reports/1
  # GET /weekly_reports/1.xml
  def show
    @weekly_report = WeeklyReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @weekly_report }
    end
  end

  # GET /weekly_reports/new
  # GET /weekly_reports/new.xml
  def new
    @weekly_report = WeeklyReport.new

    @weekly_report.week_id = Week.find_week_id("#{Time.now.at_end_of_week.yesterday.year}-#{Time.now.at_end_of_week.yesterday.month}-#{Time.now.at_end_of_week.yesterday.day}")
    @weeks = Week.all(:order => :week_endDate)

    @campuses = @my.campuses_under_my_ministries_with_children(::MinistryRole::ministry_roles_that_grant_stats_access)
    @weekly_report.campus_id = get_ministry.unique_campuses.first.id

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @weekly_report }
    end
  end

  # GET /weekly_reports/1/edit
  def edit
    @weekly_report = WeeklyReport.find(params[:id])
  end

  # POST /weekly_reports
  # POST /weekly_reports.xml
  def create

#    make sure the report is for my staff id and that I have a min inv at this campus with a role that allows me to submit stats, do this in before filter?

    staff_id = @person.cim_hrdb_staff.id
    @weekly_report = WeeklyReport.find(:first, :conditions => { :week_id => params[:weekly_report][:week_id], :staff_id => staff_id, :campus_id => params[:weekly_report][:campus_id] })

    if @weekly_report
      @weekly_report.update_attributes(params[:weekly_report])
      notice = 'Your weekly numbers were successfully re-submitted.'
    else
      @weekly_report = WeeklyReport.new(params[:weekly_report])
      @weekly_report.staff_id = @person.cim_hrdb_staff.id
      notice = 'Your weekly numbers were successfully submitted.'
    end

    respond_to do |format|
      if @weekly_report.save
        flash[:notice] = notice
        format.html { redirect_to(url_for(:controller => :stats, :action => :index)) }
        format.xml  { render :xml => @weekly_report, :status => :created, :location => @weekly_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @weekly_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /weekly_reports/1
  # PUT /weekly_reports/1.xml
  def update
    @weekly_report = WeeklyReport.find(params[:id])

    respond_to do |format|
      if @weekly_report.update_attributes(params[:weekly_report])
        flash[:notice] = 'Your weekly numbers were successfully submitted.'
        format.html { redirect_to(url_for(:controller => :stats, :action => :index)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @weekly_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /weekly_reports/1
  # DELETE /weekly_reports/1.xml
  def destroy
    @weekly_report = WeeklyReport.find(params[:id])
    @weekly_report.destroy

    unless @weekly_report.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete weekly numbers because:"
      @weekly_report.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(weekly_reports_url) }
      format.xml  { head :ok }
    end
  end
end
