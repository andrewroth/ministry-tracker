class SummerReportsController < ApplicationController
  unloadable

  include Searching

  before_filter :setup_session_for_search, :only => [:search_for_reviewers]
  before_filter :get_query, :only => [:search_for_reviewers]
  before_filter :get_contact_person

  before_filter :get_summer_year_and_weeks
  before_filter :remove_self_from_reviewers, :only => [:create, :update]

  SUMMER_START_MONTH = 4 # april
  SUMMER_END_MONTH = 8 # august
  SUMMER_START_DAY = 17 # april 17th
  SUMMER_END_DAY = 14 # august 14th


  
  def index
    @report_for_this_summer = @me.summer_reports.first(:conditions => {:year_id => @current_year.id})

    @reports_to_review = SummerReportReviewer.all(:joins => :summer_report,
      :conditions => ["#{SummerReport.__(:year_id)} = ? and #{SummerReportReviewer.__(:person_id)} = ?", @current_year.id, @my.id]).present?
    
    @num_reports_to_review = SummerReportReviewer.all(:joins => :summer_report,
      :conditions => ["#{SummerReport.__(:year_id)} = ? and #{SummerReportReviewer.__(:person_id)} = ? and " +
          "(#{SummerReportReviewer._(:reviewed)} is null or #{SummerReportReviewer._(:reviewed)} = ?)", @current_year.id, @my.id, false]).size

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def show
    @summer_report = SummerReport.find(params[:id])
    @person = @summer_report.person

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  def new # edit is also done through this action
    
    @report_for_this_summer = @me.summer_reports.first(:conditions => {:year_id => @current_year.id})

    if @report_for_this_summer.present?
      @summer_report = @report_for_this_summer
    else
      @summer_report = SummerReport.new
      @summer_report.summer_report_weeks_attributes = @summer_weeks.collect{|week| {:week_id => week.id} }
      @summer_report.support_coach = false if @summer_report.support_coach.nil?
    end

    respond_to do |format|
      if @me.summer_reports.all(:conditions => {:year_id => @current_year.id}).blank? || @summer_report.disapproved?
        format.html # new.html.erb
      else
        flash[:notice] = "You've already submitted a summer schedule for this year. If you'd like to edit your schedule it must first be disapproved."
        format.html { redirect_to(:action => "index") }
      end
    end
  end


  def create
    @summer_report = SummerReport.new(params[:summer_report])
    @summer_report.person_id = @me.id
    @summer_report.year_id = @current_year.id

    respond_to do |format|
      if @summer_report.save

        @summer_report.send_later(:send_submission_email, base_url)

        flash[:notice] = 'Your summer schedule was successfully submitted and your reviewers will be notified by email.'
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
        
        # reset the review statuses
        @summer_report.summer_report_reviewers.each {|r| r.reviewed = nil; r.approved = nil; r.save; }

        @summer_report.send_later(:send_submission_email, base_url)

        flash[:notice] = 'Your summer schedule was successfully submitted and your reviewers will be notified by email.'
        format.html { redirect_to(:action => "index") }
      else
        format.html { render :action => "new" }
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


  def report_staff_answers
    mid = params[:summer_report_ministry].present? ? params[:summer_report_ministry] : get_ministry.id
    @summer_report_ministry = Ministry.find(mid)

    ministry_ids = @summer_report_ministry.myself_and_descendants.collect{|m| m.id}
    @summer_reports = SummerReport.all(:joins => {:person => [:ministry_involvements]},
                                       :conditions => ["#{MinistryInvolvement._(:ministry_id)} in (?) and #{SummerReport.__(:year_id)} = ?", ministry_ids, @current_year.id],
                                       :group => "#{SummerReport._(:id)}",
                                       :order => "#{Person._(:first_name)}, #{Person._(:last_name)}")
    
    respond_to do |format|
      format.html
    end
  end


  def report_compliance
    @summer_report_ministry = Ministry.find(2)
    
    summer_reports = SummerReport.all(:include => [:summer_report_reviewers], :conditions => {:year_id => @current_year.id})
    
    @approved_reports = []
    @disapproved_reports = []
    @waiting_reports = []

    summer_reports.each do |r|
      if r.approved?
        @approved_reports << r
      elsif r.disapproved?
        @disapproved_reports << r
      else
        @waiting_reports << r
      end
    end

    reported_people_ids = [0] << @approved_reports.collect{|r| r.person_id} << @disapproved_reports.collect{|r| r.person_id} << @waiting_reports.collect{|r| r.person_id}
    reported_people_ids.flatten!

    @not_submitted_people = Person.all(:joins => {:ministry_involvements => :ministry_role},
      :conditions => ["#{MinistryRole._(:type)} = 'StaffRole' && #{MinistryRole._(:involved)} = 1 && #{Person.table_name}.#{Person._(:id)} not in (?)", reported_people_ids],
      :group => "#{Person.table_name}.#{Person._(:id)}",
      :order => "#{Person._(:first_name)}, #{Person._(:last_name)}")

    respond_to do |format|
      format.html
    end
  end


  private

  # find the weeks that make up summer
  def get_summer_year_and_weeks
    @current_year = Year.current

    summer_start_date = Date.new(@current_year.desc[-4..-1].to_i, SUMMER_START_MONTH, SUMMER_START_DAY)
    summer_end_date =   Date.new(@current_year.desc[-4..-1].to_i, SUMMER_END_MONTH, SUMMER_END_DAY)

    summer_start_week = Week.find_week_containing_date(summer_start_date)
    summer_end_week = Week.find_week_containing_date(summer_end_date)
    
    @summer_weeks = Week.all(:conditions => ["#{Week._(:end_date)} >= ? AND #{Week._(:end_date)} <= ?", summer_start_week.end_date, summer_end_week.end_date])
  end


  def get_contact_person # for questions about summer schedules
    begin
      @contact_person = Person.find(1698) #currently this is Selene Lau
      @contact_phone = "604-514-1970"
    rescue
      @contact_person = @contact_phone = nil
    end
  end


  def remove_self_from_reviewers
    # make sure none of the reviewers are me
    if params[:summer_report]["summer_report_reviewers_attributes"].present?
      params[:summer_report]["summer_report_reviewers_attributes"].each do |k,v|
        v["_destroy"] = true if v["person_id"].to_i == @my.id # this is a Rails nested attributes thing
      end
    end
  end



end
