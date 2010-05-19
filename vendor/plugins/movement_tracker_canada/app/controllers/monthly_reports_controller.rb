class MonthlyReportsController < ApplicationController
  unloadable

  # GET /monthly_reports
  # GET /monthly_reports.xml
  def index
    @monthly_reports = MonthlyReport.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @monthly_reports }
    end
  end

  # GET /monthly_reports/1
  # GET /monthly_reports/1.xml
  def show
    @monthly_report = MonthlyReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @monthly_report }
    end
  end

  def setup_for_record(month_id, campus_id)
debugger
    @monthly_report = MonthlyReport.find(:first, :conditions => { :month_id => month_id, :campus_id => campus_id })
    @monthly_report ||= MonthlyReport.new 

    @monthly_report.month_id = month_id
    @monthly_report.campus_id = campus_id
    
    @months = Month.find(:all, :conditions => "month_number <= #{ Time.now.month } AND month_calendaryear <= #{ Time.now.year }", :order => "month_calendaryear, month_number")

    @campuses = @my.campuses_under_my_ministries_with_children(::MinistryRole::ministry_roles_that_grant_access("monthly_reports", "new"))

  end

  # GET /monthly_reports/new
  # GET /monthly_reports/new.xml
  def new
  
    current_month_id = Month.find_month_id("#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}")
    current_campus_id = get_ministry.unique_campuses.first.id
    
    setup_for_record(current_month_id, current_campus_id)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @monthly_report }
    end
  end

  # GET /monthly_reports/1/edit
  def edit
    @monthly_report = MonthlyReport.find(params[:id])
  end

  # POST /monthly_reports
  # POST /monthly_reports.xml
  def create

    staff_id = @person.cim_hrdb_staff.id
    @monthly_report = MonthlyReport.find(:first, :conditions => { :month_id => params[:monthly_report][:month_id], :campus_id => params[:monthly_report][:campus_id] })

    if @monthly_report
      @monthly_report.update_attributes(params[:monthly_report])
      notice = 'Your monthly numbers were successfully re-submitted.'
    else
      @monthly_report = MonthlyReport.new(params[:monthly_report])
      notice = 'Your monthly numbers were successfully submitted.'
    end

    respond_to do |format|
      if @monthly_report.save
        flash[:notice] = notice
        format.html { redirect_to(url_for(:controller => :stats, :action => :index)) }
        format.xml  { render :xml => @monthly_report, :status => :created, :location => @monthly_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @monthly_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /monthly_reports/1
  # PUT /monthly_reports/1.xml
  def update
    @monthly_report = MonthlyReport.find(:first, :conditions => { :month_id => params[:monthly_report][:month_id], :campus_id => params[:monthly_report][:campus_id] })

    if @monthly_report
      success_update = true if @monthly_report.update_attributes(params[:monthly_report])
    else
      success_update = true if @monthly_report = MonthlyReport.new(params[:monthly_report])
    end

    respond_to do |format|
      if success_update && @monthly_report.save
        flash[:notice] = 'Your monthly numbers were successfully submitted.'
        format.html { redirect_to(url_for(:controller => :stats, :action => :index)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @monthly_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /monthly_reports/1
  # DELETE /monthly_reports/1.xml
  def destroy
    @monthly_report = MonthlyReport.find(params[:id])
    @monthly_report.destroy

    unless @monthly_report.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete monthly numbers because:"
      @monthly_report.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(monthly_reports_url) }
      format.xml  { head :ok }
    end
  end

  def select_monthly_report
    setup_for_record(params['month_id'], params['campus_id'])
  
    respond_to do |format|
      format.js
    end
  end

end

