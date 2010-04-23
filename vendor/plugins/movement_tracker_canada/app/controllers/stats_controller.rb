class StatsController < ApplicationController
  unloadable

  skip_before_filter :authorization_filter, :only => [:campuses_collection_select]


  NO_CAMPUSES_UNDER_MINISTRY = -1
  ALL_CAMPUSES_UNDER_MINISTRY = 0

  DEFAULT_REPORT_TIME = 'semester'
  DEFAULT_SUMMARY = 'true'


  def index
    session[:stats_ministry_id] = get_ministry.id unless session[:stats_ministry_id].present?
    session[:stats_summary] = DEFAULT_SUMMARY unless session[:stats_summary].present?
    session[:stats_time] = DEFAULT_REPORT_TIME unless session[:stats_time].present?

    setup_stats_report_from_session
  end


  def select_report
    session[:stats_ministry_id] = Ministry.find(params['ministry']).id
    session[:stats_summary] = params['summary']
    session[:stats_time] = params['time']

    setup_stats_report_from_session

    case
    when @stats_summary && @stats_time == 'year'
      setup_summary_by_year
    when @stats_summary && @stats_time == 'semester'
      setup_summary_by_semester
    when @stats_summary && @stats_time == 'month'
      setup_summary_by_month
      
    when !@stats_summary && @stats_time == 'year'
      setup_campus_by_year
    when !@stats_summary && @stats_time == 'semester'
      setup_campus_by_semester
    when !@stats_summary && @stats_time == 'month'
      setup_campus_by_month
    when !@stats_summary && @stats_time == 'week'
      setup_campus_by_week
    end

    respond_to do |format|
      format.js
    end
  end


  def indicated_decisions
    @cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    cur_id = Month.find_semester_id(@cur_month)
    @semesters = Semester.find_semesters(cur_id)
    @semester_id = Month.find_semester_id(@cur_month)
    @semester_selected = Semester.find_semester_description(@semester_id)
    @campuses = Campus.find_campuses()
  end


  def campuses_collection_select
    ministry = Ministry.find(params[:ministry])
    campuses = ministry.unique_campuses.sort { |x, y| x.campus_desc <=> y.campus_desc }

    if campuses.size > 0
      @options = campuses.size > 1 ? [{:key => ALL_CAMPUSES_UNDER_MINISTRY, :value => "Report all campuses under #{ministry.name}"}] : []

      campuses.each do |campus|
        @options << { :key => campus.id, :value => campus.campus_desc }
      end
    else
      @options = [{:key => NO_CAMPUSES_UNDER_MINISTRY, :value => "There are no campuses under #{ministry.name}"}]
    end

    @form_name = 'report'
    @select_value = 'campus_id'
    @selected_key = params[:campus_id]

    render :partial => "collection_select"
  end


  def semester_at_a_glance

    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"

    @ministries = my_ministries_for_stats.sort { |x, y| x.name <=> y.name }

    if params[:report].nil?

      @stats_ministry_id = get_ministry.id
      @semester_id = Month.find_semester_id(cur_month)
      @campus_id = ALL_CAMPUSES_UNDER_MINISTRY

    else # set the appropriate variables to the parameters

      @stats_ministry_id = params[:report]['ministry']
      @stats_ministry_selected = Ministry.find(@stats_ministry_id)

      @campus_id = params[:report]['campus_id']
      case @campus_id.to_i
      when ALL_CAMPUSES_UNDER_MINISTRY
        @campus_selected_description = "All campuses under #{@stats_ministry_selected.name}"
        @campuses_selected = @stats_ministry_selected.unique_campuses
      when NO_CAMPUSES_UNDER_MINISTRY
        @campus_selected = nil
        @campuses_selected = nil
      else
        @campus_selected_description = Campus.find(@campus_id).campus_desc
        @campuses_selected = [Campus.find(@campus_id)]
      end

      @semester_id = Semester.find_semester_id(params[:report]['semester'])

      @staff_id = authorized?(:index, :stats) ? nil : @me.cim_hrdb_staff.id
      @staff_hash = {}
      @campuses_selected.each do |campus|
        @staff_hash.merge!( { campus.id => WeeklyReport.find_staff(@semester_id, campus.id, @staff_id) } )
      end

      @weeks = Week.find_weeks_in_semester(@semester_id)
      @months = Month.find_months_by_semester(@semester_id)

      flash[:notice] = @staff_hash.size == 0 ? "Sorry, no stats were found for your selection!" : nil
    end


    @semester_selected = Semester.find_semester_description(@semester_id)

    # the code below ensures that months that haven't occurred yet aren't listed
    cur_id = Month.find_semester_id(cur_month)
    @semesters = Semester.find_semesters(cur_id)
    @cur_semester = Semester.find_semester_description(cur_id)
    
  end


  def summary_by_campus

    # find the current month
    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"

    @ministries = my_ministries_for_stats.sort { |x, y| x.name <=> y.name }

    if params[:report].nil?

      @stats_ministry_id = get_ministry.id
      @semester_id = Month.find_semester_id(cur_month)

    else
      @stats_ministry_id = params[:report]['ministry']
      @stats_ministry_selected = Ministry.find(@stats_ministry_id)
      
      @semester_id = Semester.find_semester_id(params[:report]['semester'])

      @campuses = @stats_ministry_selected.unique_campuses.sort { |x, y| x.campus_desc <=> y.campus_desc }
      
      flash[:notice] = @campuses.size == 0 ? "Sorry, no stats were found for your selection!" : nil
    end

    @semester_selected = Semester.find_semester_description(@semester_id)

    # the code below ensures that months that haven't occurred yet aren't listed
    cur_id = Month.find_semester_id(cur_month)
    @semesters = Semester.find_semesters(cur_id)
    @cur_semester = Semester.find_semester_description(cur_id)
    @year_selected = Year.find_year_description(Semester.find_semester_year(@semester_id))

  end


  def summary_by_month
    
    # find the current month
    @cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"

    @ministries = my_ministries_for_stats.sort { |x, y| x.name <=> y.name }

    if params[:report].nil?
      @stats_ministry_id = get_ministry.id

      @semester_id = Month.find_semester_id(@cur_month)
      @semester_selected = Semester.find_semester_description(@semester_id)
    else
      @stats_ministry_id = params[:report]['ministry']
      @stats_ministry_selected = Ministry.find(@stats_ministry_id)
      
      @semester_selected = params[:report]['semester']
      @semester_id = Semester.find_semester_id(@semester_selected)
    end

    # Initialize Variables Used by View

    @months = Month.find_months_by_semester(@semester_id)

    # the code below ensures that semesters that haven't occurred yet aren't listed
    cur_id = Month.find_semester_id(@cur_month)
    @semesters = Semester.find_semesters(cur_id)

  end


  def summary_by_week

    # find the current month
    @cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"

    @ministries = my_ministries_for_stats.sort { |x, y| x.name <=> y.name }

    if params[:report].nil?
      @stats_ministry_id = get_ministry.id

      @month_selected = @cur_month
    else
      @stats_ministry_id = params[:report]['ministry']
      @stats_ministry_selected = Ministry.find(@stats_ministry_id)
      
      @month_selected = params[:report]['month']
    end

    # Initialize Variables Used by View

    @month_id = Month.find_month_id(@month_selected)
    @weeks = Week.find_weeks_in_month(@month_id)

    # the code below ensures that months that haven't occurred yet aren't listed
    cur_id = Month.find_month_id(@cur_month)
    @months = Month.find_months(cur_id)

  end


  def how_people_came_to_christ

    # find the current month
    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    # find the current year id
    current_year_id = Month.find_year_id(cur_month)

    @ministries = my_ministries_for_stats.sort { |x, y| x.name <=> y.name }

    if params[:report].nil?
      
      @stats_ministry_id = get_ministry.id

      @year_id = current_year_id
      @year_selected = Year.find_year_description(@year_id)
    else

      @stats_ministry_id = params[:report]['ministry']
      @stats_ministry_selected = Ministry.find(@stats_ministry_id)

      @year_selected = params[:report]['year']
      @year_id = Year.find_year_id(@year_selected)

      
      # calculate the totals and percentages of the various indicated decisions methods

      @methods = Array.new(Prcmethod.last.id+1){0}
      @completed = Array.new(Prcmethod.last.id+1){0}

      semesters = Semester.find_semesters_by_year(@year_id) # find all semesters in a year
      year_start = Date.parse_date( semesters.first.semester_startDate )
      year_end   = Date.parse_date( Semester.find(semesters.last.id + 1).semester_startDate )

      campus_ids = Ministry.find(@stats_ministry_id).unique_campuses.collect {|c| c.id}
      prcs = Prc.all(:conditions => ["#{_(:prc_date, :prc)} >= ? and #{_(:prc_date, :prc)} < ? and #{_(:campus_id, :prc)} in (?)", year_start, year_end, campus_ids])
      @total = prcs.size

      prcs.each do |prc|
        @methods[prc.prcMethod_id] += 1
        @completed[prc.prcMethod_id] += 1 if prc.prc_7upCompleted == 1
      end
    end

    # Initialize Variables Used by View

    @years = Year.find_years(current_year_id)
  end


  def year_summary

    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    current_year_id = Month.find_year_id(cur_month)

    @ministries = my_ministries_for_stats.sort { |x, y| x.name <=> y.name }
    
    if params[:report].nil?

      @stats_ministry_id = get_ministry.id
      @campus_id = ALL_CAMPUSES_UNDER_MINISTRY
      @year_id = current_year_id
      @year_selected = Year.find_year_description(@year_id)

    else

      @stats_ministry_id = params[:report]['ministry']
      @stats_ministry_selected = Ministry.find(@stats_ministry_id)

      @campus_id = params[:report]['campus_id']
      case @campus_id.to_i
      when ALL_CAMPUSES_UNDER_MINISTRY
        @campus_selected_description = "All campuses under #{@stats_ministry_selected.name}"
        @campuses_selected = @stats_ministry_selected.unique_campuses
      when NO_CAMPUSES_UNDER_MINISTRY
        @campus_selected = nil
        @campuses_selected = nil
      else
        @campus_selected_description = Campus.find(@campus_id).campus_desc
        @campuses_selected = [Campus.find(@campus_id)]
      end

      @year_selected = params[:report]['year']
      @year_id = Year.find_year_id(@year_selected)
    end

    # Initialize Variables Used by View

    @years = Year.find_years(current_year_id)
    @campuses = Campus.find_campuses()
  end


  private

  def my_ministries_for_stats
    unless is_ministry_admin
      @me.ministries_involved_in_with_children(::MinistryRole::ministry_roles_that_grant_stats_access)
    else
      ::Ministry.first.myself_and_descendants
    end
  end


  def setup_stats_report_from_session

    @stats_ministry_id =  session[:stats_ministry_id].to_i
    @stats_ministry = Ministry.find(@stats_ministry_id)

    @stats_summary = session[:stats_summary] == DEFAULT_SUMMARY ? true : false

    @stats_time = session[:stats_time]



    # if a ministry has only one campus disable campus drill-down and force summary reports only (which means no week report either)
    @oneCampusMinistry = @stats_ministry.unique_campuses.size <= 1 ? true : false
    if @oneCampusMinistry
      @stats_summary = true
      session[:stats_summary] = DEFAULT_SUMMARY
    end

    if @stats_time == "week" && @stats_summary
      @stats_time = session[:stats_time] = DEFAULT_REPORT_TIME
    end

    @selected_results_div_id = "stats#{@stats_time.capitalize}Results"
    @selected_time_tab_id = @stats_time
  end


  def setup_summary_by_year
    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    current_year_id = Month.find_year_id(cur_month)

    @campuses_selected = @stats_ministry.unique_campuses

    session[:stats_year] = params[:year] if params[:year].present?
    session[:stats_year] = current_year_id unless session[:stats_year].present?
    @year_id = session[:stats_year]
    
    @years = Year.all

    @report_description = "Summary of #{@stats_ministry.name} during #{Year.find(@year_id).description}"
    @results_partial = "summary_by_year"
    @tab_select_partial = "select_year"
  end


  def setup_summary_by_semester
    @cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"

    session[:stats_semester] = params[:semester] if params[:semester].present?
    session[:stats_semester] = Month.find_semester_id(@cur_month) unless session[:stats_semester].present?
    @semester_id = session[:stats_semester]

    @months = Month.find_months_by_semester(@semester_id)

    # ensures that semesters that haven't occurred yet aren't listed
    cur_semester_id = Month.find_semester_id(@cur_month)
    @semesters = Semester.find(:all, :conditions => ["#{_(:id, :semester)} <= ?",cur_semester_id])

    @report_description = "Summary of #{@stats_ministry.name} during #{Semester.find(:first, :conditions => {:semester_id => @semester_id}).description}"
    @results_partial = "summary_by_semester"
    @tab_select_partial = "select_semester"
  end


  def setup_summary_by_month
    @cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    @cur_month_id = Month.find_month_id(@cur_month)

    session[:stats_month] = params[:month] if params[:month].present?
    session[:stats_month] = @cur_month_id unless session[:stats_month].present?
    @month_id = session[:stats_month]

    @weeks = Week.find_weeks_in_month(@month_id)

    @months = Month.find(:all, :conditions => ["#{_(:id, :month)} <= ?", @cur_month_id])

    @report_description = "Summary of #{@stats_ministry.name} during #{Month.find(:first, :conditions => {:month_id => @month_id}).description}"
    @results_partial = "summary_by_month"
    @tab_select_partial = "select_month"
  end


  def setup_campus_by_year
    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    current_year_id = Month.find_year_id(cur_month)


    session[:stats_year] = params[:year] if params[:year].present?
    session[:stats_year] = current_year_id unless session[:stats_year].present?
    @year_id = session[:stats_year]


    year = Year.find(@year_id)
    
    first_end_date = year.months.first.weeks.all(:order => "week_endDate asc").first.end_date

    if(year.months.last.weeks.empty?)
      last_end_date = Week.all(:order => "week_endDate asc").last.end_date
    else
      last_end_date = year.months.last.weeks.all(:order => "week_endDate asc").last.end_date
    end

    @campuses = @stats_ministry.unique_campuses.sort{ |c1, c2| c1.name <=> c2.name }
    @campus_stats = get_campus_stats_hash_for_date_range(first_end_date, last_end_date, @campuses)
    @campus_prcs = get_campus_prcs_hash_for_date_range(first_end_date, last_end_date, @campuses)

    @years = Year.all.select{|y| y.months.any? && y.months.first.weeks.any?}

    @report_description = "Campuses under #{@stats_ministry.name} during #{year.description}"
    @results_partial = "campuses_by_week_range"
    @tab_select_partial = "select_year"
  end


  def setup_campus_by_semester
    @cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"

    session[:stats_semester] = params[:semester] if params[:semester].present?
    session[:stats_semester] = Month.find_semester_id(@cur_month) unless session[:stats_semester].present?
    @semester_id = session[:stats_semester]


    semester = Semester.find(@semester_id)

    first_end_date = semester.weeks.all(:order => "week_endDate asc").first.end_date
    last_end_date =  semester.weeks.all(:order => "week_endDate asc").last.end_date

    @campuses = @stats_ministry.unique_campuses.sort{ |c1, c2| c1.name <=> c2.name }
    @campus_stats = get_campus_stats_hash_for_date_range(first_end_date, last_end_date, @campuses)
    @campus_prcs = get_campus_prcs_hash_for_date_range(first_end_date, last_end_date, @campuses)

    # ensures that semesters that haven't occurred yet aren't listed
    cur_semester_id = Month.find_semester_id(@cur_month)
    @semesters = Semester.find(:all, :conditions => ["#{_(:id, :semester)} <= ?",cur_semester_id])

    @report_description = "Campuses under #{@stats_ministry.name} during #{semester.description}"
    @results_partial = "campuses_by_week_range"
    @tab_select_partial = "select_semester"
  end


  def setup_campus_by_month
    @cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    @cur_month_id = Month.find_month_id(@cur_month)

    session[:stats_month] = params[:month] if params[:month].present?
    session[:stats_month] = @cur_month_id unless session[:stats_month].present?
    @month_id = session[:stats_month]

    month = Month.find(@month_id)

    first_week_end_date = month.weeks.all(:order => "week_endDate asc").first.end_date
    last_week_end_date =  month.weeks.all(:order => "week_endDate asc").last.end_date

    @campuses = @stats_ministry.unique_campuses.sort{ |c1, c2| c1.name <=> c2.name }
    @campus_stats = get_campus_stats_hash_for_date_range(first_week_end_date, last_week_end_date, @campuses)
    @campus_prcs = get_campus_prcs_hash_for_date_range(first_week_end_date, last_week_end_date, @campuses)


    @weeks = Week.find_weeks_in_month(@month_id)
    @months = Month.find(:all, :conditions => ["#{_(:id, :month)} <= ?", @cur_month_id])

    @report_description = "Campuses under #{@stats_ministry.name} during #{month.description}"
    @results_partial = "campuses_by_week_range"
    @tab_select_partial = "select_month"
  end


  def setup_campus_by_week
    today = "#{Time.now.year()}-#{Time.now.month()}-#{Time.now.day()}"
    cur_week = Week.all(:conditions => ["#{_(:end_date, :week)} >= ?", today], :order => "week_endDate asc").first

    session[:stats_week] = params[:week] if params[:week].present?
    session[:stats_week] = cur_week.id unless session[:stats_week].present?
    @week_id = session[:stats_week]
    week = Week.find(@week_id)
    
    first_week_end_date = week.end_date
    last_week_end_date =  week.end_date

    @campuses = @stats_ministry.unique_campuses.sort{ |c1, c2| c1.name <=> c2.name }
    @campus_stats = get_campus_stats_hash_for_date_range(first_week_end_date, last_week_end_date, @campuses)
    @campus_prcs = get_campus_prcs_hash_for_date_range(first_week_end_date, last_week_end_date, @campuses)


    @weeks = Week.all(:conditions => ["#{_(:end_date, :week)} <= ?", cur_week.end_date], :order => :week_endDate)

    @report_description = "Campuses under #{@stats_ministry.name} during the week ending on #{week.end_date}"
    @results_partial = "campuses_by_week_range"
    @tab_select_partial = "select_week"
  end


  def get_campus_stats_hash_for_date_range(first_week_end_date, last_week_end_date, campuses)
    campus_stats = {}

    campuses.each do |campus|
      stats = ::WeeklyReport.find_all_stats_by_date_range_and_campus(first_week_end_date, last_week_end_date, campus.id)

      campus_stats.merge!({campus.id => stats})
    end

    campus_stats
  end


  def get_campus_prcs_hash_for_date_range(first_week_end_date, last_week_end_date, campuses)
    campus_prcs = {}

    # since we're working with the end dates of weeks we need to get the end date of the week previous to the first week to include all PRCs in the first week
    first_week_end_date = Date.parse(first_week_end_date.to_s) - 7

    campuses.each do |campus|
      prcs = ::Prc.count_by_campus(first_week_end_date, last_week_end_date, campus.id)

      campus_prcs.merge!({campus.id => prcs})
    end

    campus_prcs
  end
end
