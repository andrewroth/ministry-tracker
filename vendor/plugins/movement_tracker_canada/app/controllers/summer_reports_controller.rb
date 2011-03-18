class SummerReportsController < ApplicationController
  unloadable

  include Searching

  before_filter :setup_session_for_search, :only => [:search_for_reviewers]
  before_filter :get_query, :only => [:search_for_reviewers]

  before_filter :get_summer_weeks, :only => [:new, :create, :update, :edit, :show]

  SUMMER_START_MONTH = 4 # april
  SUMMER_END_MONTH = 8 # august
  SUMMER_START_DAY = 17 # april 17th
  SUMMER_END_DAY = 14 # august 14th


  
  def index
    @current_year = Year.current
    @report_for_this_summer = @me.summer_reports.first(:conditions => {:year_id => @current_year.id})

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def show
    @summer_report = SummerReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  def new
    @summer_report = SummerReport.new
    @summer_report.summer_report_weeks_attributes = @summer_weeks.collect{|week| {:week_id => week.id} }

    respond_to do |format|
      if @me.summer_reports.all(:conditions => {:year_id => Year.current.id}).blank?
        format.html # new.html.erb
      else
        flash[:notice] = "You've already submitted a summer report for this year, you can't submit another one."
        format.html { redirect_to(:action => "index") }
      end
    end
  end


  def edit
    @summer_report = SummerReport.find(params[:id])
  end


  def create
    @summer_report = SummerReport.new(params[:summer_report])
    @summer_report.person_id = @me.id
    @summer_report.year_id = Year.current.id

    respond_to do |format|
      if @summer_report.save
        flash[:notice] = 'Your summer schedule was successfully submitted and is now waiting for review.'
        format.html { redirect_to(:action => "index") }
      else
        format.html { render :action => "new" }
      end
    end
  end


  def update
    @summer_report = SummerReport.find(params[:id])

    respond_to do |format|
      if @summer_report.update_attributes(params[:summer_report])
        flash[:notice] = 'Your summer schedule was successfully submitted and is now waiting for review.'
        format.html { redirect_to(:action => "index") }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  def search_for_reviewers
    if @q.present?
      params[:per_page] = Searching::DEFAULT_NUM_SEARCH_RESULTS
      @people = search_people(@q) if session[:search][:authorized_to_search_people]
    end

    respond_to do |format|
      format.js
    end
  end


  private

  # find the weeks that make up summer
  def get_summer_weeks
    @current_year = Year.current

    summer_start_date = Date.new(@current_year.desc[-4..-1].to_i, SUMMER_START_MONTH, SUMMER_START_DAY)
    summer_end_date =   Date.new(@current_year.desc[-4..-1].to_i, SUMMER_END_MONTH, SUMMER_END_DAY)

    summer_start_week = Week.find_week_containing_date(summer_start_date)
    summer_end_week = Week.find_week_containing_date(summer_end_date)
    
    @summer_weeks = Week.all(:conditions => ["#{Week._(:end_date)} >= ? AND #{Week._(:end_date)} <= ?", summer_start_week.end_date, summer_end_week.end_date])
  end
  

end
