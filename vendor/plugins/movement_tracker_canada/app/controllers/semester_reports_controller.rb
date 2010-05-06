class SemesterReportsController < ApplicationController
  unloadable

  # GET /semester_reports
  # GET /semester_reports.xml
  def index
    @semester_reports = SemesterReport.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @semester_reports }
    end
  end

  # GET /semester_reports/1
  # GET /semester_reports/1.xml
  def show
    @semester_report = SemesterReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @semester_report }
    end
  end

  # GET /semester_reports/new
  # GET /semester_reports/new.xml
  def new
  
    current_semester_id = Month.find_semester_id("#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}")
    current_campus_id = get_ministry.unique_campuses.first.id
    
    @semester_report = SemesterReport.find(:first, :conditions => { :semester_id => current_semester_id, :campus_id => current_campus_id })
    @semester_report ||= SemesterReport.new 

    @semester_report.semester_id = current_semester_id
    @semester_report.campus_id = current_campus_id
    
    @semesters = Semester.all(:order => :semester_startDate)

    @campuses = @my.campuses_under_my_ministries_with_children(::MinistryRole::ministry_roles_that_grant_access("semester_reports", "new"))

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @semester_report }
    end
  end

  # GET /semester_reports/1/edit
  def edit
    @semester_report = SemesterReport.find(params[:id])
  end

  # POST /semester_reports
  # POST /semester_reports.xml
  def create

    staff_id = @person.cim_hrdb_staff.id
    @semester_report = SemesterReport.find(:first, :conditions => { :semester_id => params[:semester_report][:semester_id], :campus_id => params[:semester_report][:campus_id] })

    if @semester_report
      @semester_report.update_attributes(params[:semester_report])
      notice = 'Your semester numbers were successfully re-submitted.'
    else
      @semester_report = SemesterReport.new(params[:semester_report])
      notice = 'Your semester numbers were successfully submitted.'
    end

    respond_to do |format|
      if @semester_report.save
        flash[:notice] = notice
        format.html { redirect_to(url_for(:controller => :stats, :action => :index)) }
        format.xml  { render :xml => @semester_report, :status => :created, :location => @semester_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @semester_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /semester_reports/1
  # PUT /semester_reports/1.xml
  def update
    @semester_report = SemesterReport.find(:first, :conditions => { :semester_id => params[:semester_report][:semester_id], :campus_id => params[:semester_report][:campus_id] })

    if @semester_report
      success_update = true if @semester_report.update_attributes(params[:semester_report])
    else
      success_update = true if @semester_report = SemesterReport.new(params[:semester_report])
    end

    respond_to do |format|
      if success_update && @semester_report.save
        flash[:notice] = 'Your semester numbers were successfully submitted.'
        format.html { redirect_to(url_for(:controller => :stats, :action => :index)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @semester_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /semester_reports/1
  # DELETE /semester_reports/1.xml
  def destroy
    @semester_report = SemesterReport.find(params[:id])
    @semester_report.destroy

    unless @semester_report.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete semester numbers because:"
      @semester_report.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(semester_reports_url) }
      format.xml  { head :ok }
    end
  end
end
