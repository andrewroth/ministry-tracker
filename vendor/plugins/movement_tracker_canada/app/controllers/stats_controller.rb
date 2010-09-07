require "date"
class StatsController < ApplicationController
  unloadable

  skip_before_filter :authorization_filter, :only => [:select_report, :campuses_collection_select]


  NO_CAMPUSES_UNDER_MINISTRY = -1
  ALL_CAMPUSES_UNDER_MINISTRY = 0

  DEFAULT_REPORT_TIME = 'semester'
  DEFAULT_SUMMARY = 'true'
  REPORT_TYPE_C4C = 'c4c'
  DEFAULT_REPORT_TYPE = :c4c 
  SUMMARY = 'summary'
  STAFF_DRILL_DOWN = 'staff_drill_down'
  CAMPUS_DRILL_DOWN = 'campus_drill_down'
  DEFAULT_REPORT_SCOPE = SUMMARY 


  def index
    session[:stats_ministry_id] = get_ministry.id unless session[:stats_ministry_id].present?
    session[:stats_time] = DEFAULT_REPORT_TIME unless session[:stats_time].present?
    session[:stats_report_type] = DEFAULT_REPORT_TYPE unless session[:stats_report_type].present?
    session[:stats_report_scope] = DEFAULT_REPORT_SCOPE unless session[:stats_report_scope].present?

    setup_stats_report_from_session
  end

  def select_c4c_report
    case @report_scope
      when SUMMARY
        select_c4c_summary
      when CAMPUS_DRILL_DOWN
        setup_campus_drill_down
        #select_c4c_campus_drill_down
      when STAFF_DRILL_DOWN
        setup_staff_drill_down
      end
  end

  def select_c4c_summary
    case @stats_time
      when 'year'
        setup_summary_by_year
      when 'semester'
        setup_summary_by_semester
      when 'month'
        setup_summary_by_month
    end
  end

  def select_c4c_campus_drill_down
    case @stats_time
      when 'year'
         setup_campus_by_year
      when 'semester'
        setup_campus_by_semester
      when 'month'
        setup_campus_by_month
      when 'week'
        setup_campus_by_week
    end
  end

  def select_report
    session[:stats_ministry_id] = params['ministry'] if params['ministry'].present?
    session[:stats_time] = params['time']
    session[:stats_report_type] = params['report_type'] if params['report_type'].present?
    session[:stats_report_scope] = params['report_scope'] if params['report_scope'].present?

    setup_stats_report_from_session

    case @report_type
      when 'comp'
        setup_compliance_report
      when 'hpctc'
        setup_how_people_came_to_christ_report
      when 'story'
        setup_story_report
      else
        # c4c, p2c and ccci are all handled here:
        select_c4c_report
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

      setup_campus_ids
      
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

  def my_ministries_for_stats(action)
    unless is_ministry_admin
      @me.ministries_involved_in_with_children(::MinistryRole::ministry_roles_that_grant_access("stats", action))
    else
      ::Ministry.first.myself_and_descendants
    end
  end


  def setup_stats_report_from_session
    @this_year = get_current_year
    @id_for_treeview = session[:stats_ministry_id]
    ministry_campus_id = @id_for_treeview.to_s.split('_')
    @stats_ministry_id =  ministry_campus_id[0].to_i
    @stats_ministry = Ministry.find(@stats_ministry_id)
    @name_for_treeview = @stats_ministry.name
    if ministry_campus_id.length > 1 
      campus = Campus.find(ministry_campus_id[1].to_i)
      @campus_ids = [campus.id]
      @ministry_name = campus.campus_desc
      @name_for_treeview = campus.campus_shortDesc
    else
      @ministry_name = @stats_ministry.name
    end
    # make sure they have access to the ministry that was selected
    # ---- for now we will just make sure that they can only select ministries they have access to
    # @stats_ministry = get_ministry.root unless @stats_ministry.person_involved_at_or_under(@me) || is_ministry_admin

    @stats_time = session[:stats_time]
    @report_type = session[:stats_report_type] 
    @report_scope = session[:stats_report_scope]
    
    # only allow campus drill-down if the ministry has more than one campus under it and the person has the correct permission at this ministry
    @oneCampusMinistry = @stats_ministry.unique_campuses.size <= 1 ? true : false
    @drillDownAccess = @me.has_permission_from_ministry_or_higher("drill_down_access", "stats", @stats_ministry)

    setup_summary_drilldown_radio_visibility
    check_stats_time_availability
    setup_reports_to_show

    @scope_radio_selected_id = report_scopes[:"#{@report_scope}"][:radio_id]
    @stats_summary = @report_scope == SUMMARY ? true : false
    
    @show_additional_report_links = (authorized?("how_people_came_to_christ", "stats")) ? true : false
    @show_ministries_under = authorized?("view_ministries_under", "stats")
 
    @selected_results_div_id = "stats#{@stats_time.capitalize}Results"
    @selected_time_tab_id = @stats_time
  end


  def setup_how_people_came_to_christ_report

    setup_campus_ids
    setup_selected_time_tab
    setup_selected_period_for_drilldown
    setup_report_description

    # calculate the totals and percentages of the various indicated decisions methods

    @methods = Array.new(Prcmethod.last.id+1){0}
    @completed = Array.new(Prcmethod.last.id+1){0}

    semesters = Semester.find_semesters_by_year(@year_id) # find all semesters in a year
    year_start = Date.parse_date( semesters.first.semester_startDate )
    year_end   = Date.parse_date( Semester.find(semesters.last.id + 1).semester_startDate )

    prcs = Prc.all(:conditions => ["#{_(:prc_date, :prc)} >= ? and #{_(:prc_date, :prc)} < ? and #{_(:campus_id, :prc)} in (?)", year_start, year_end, @campus_ids])
    @total = prcs.size

    prcs.each do |prc|
      @methods[prc.prcMethod_id] += 1
      @completed[prc.prcMethod_id] += 1 if prc.prc_7upCompleted == 1
    end


    @results_partial = "how_people_came_to_christ"
  end


  def setup_story_report
    
    setup_campus_ids
    setup_selected_time_tab
    setup_selected_period_for_drilldown
    setup_report_description


    # find the prc ('indicated decisions') data to display

    semesters = Semester.find_semesters_by_year(@year_id) # find all semesters in a year
    year_start = Date.parse_date( semesters.first.semester_startDate )
    year_end   = Date.parse_date( Semester.find(semesters.last.id + 1).semester_startDate )

    @prcs = Prc.all(:conditions => ["#{_(:prc_date, :prc)} >= ? and #{_(:prc_date, :prc)} < ? and #{_(:campus_id, :prc)} in (?)", year_start, year_end, @campus_ids], :order => 'prc_date ASC')

    @results_partial = "salvation_story_synopses"
  end


  def setup_summary_by_year
    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    current_year_id = Month.find_year_id(cur_month)

    @semester_highlights_permission = authorized?(:semester_highlights, :stats, @stats_ministry)
    @monthly_report_permission = authorized?(:monthly_report, :stats, @stats_ministry)
    setup_campus_ids

    session[:stats_year] = params[:year] if params[:year].present?
    session[:stats_year] = current_year_id unless session[:stats_year].present?
    
    @year_id = session[:stats_year]
    year = Year.find(@year_id)
    
    @years = Year.all(:conditions => ["#{_(:id, :year)} <= ?",current_year_id])

    @period_model = year.semesters
    @report_description = "Summary of #{@ministry_name} during #{Year.find(@year_id).description}"
    @results_partial = "summary_by_year"
    @tab_select_partial = "select_year"
  end

  def setup_staff_drill_down
    
    setup_campus_ids
    setup_selected_time_tab
    setup_selected_period_for_drilldown    
    setup_staffs_for_staff_drilldown(@report_scope, @stats_ministry)
    setup_report_description
   
    @results_partial = "staff_drill_down"
  end

  def setup_campus_drill_down
    
    setup_campus_ids
    setup_selected_time_tab
    setup_selected_period_for_drilldown    
    setup_report_description
   
    @results_partial = "campus_drill_down"
  end

  def setup_compliance_report
    setup_campus_ids
    setup_selected_time_tab
    setup_selected_period_for_drilldown    
    setup_staffs_for_staff_drilldown(STAFF_DRILL_DOWN, @stats_ministry)
    setup_report_description
   
    @results_partial = "compliance_report"
  end

  def setup_summary_by_semester
    @cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"

    session[:stats_semester] = params[:semester] if params[:semester].present?
    session[:stats_semester] = Month.find_semester_id(@cur_month) unless session[:stats_semester].present?
    @semester_id = session[:stats_semester]
    semester = Semester.find(@semester_id)

    setup_campus_ids    
    @monthly_report_permission = authorized?(:monthly_report, :stats, @stats_ministry)
    @period_model = @months = semester.months

    # ensures that semesters that haven't occurred yet aren't listed
    cur_semester_id = Month.find_semester_id(@cur_month)
    @semesters = Semester.find(:all, :conditions => ["#{_(:id, :semester)} <= ?",cur_semester_id])

    @report_description = "Summary of #{@ministry_name} during #{semester.description}"
    @results_partial = "summary_by_semester"
    @tab_select_partial = "select_semester"
  end


  def setup_summary_by_month
    cur_month_id = Month.find(:first, :conditions => { :month_calendaryear => Time.now.year(), :month_number => Time.now.month()}).id

    session[:stats_month] = params[:month] if params[:month].present?
    session[:stats_month] = cur_month_id unless session[:stats_month].present?
    
    cur_month = Month.find(session[:stats_month])

    @period_model = @weeks = cur_month.weeks
    setup_campus_ids    

    @months = Month.find(:all, :conditions => ["#{_(:id, :month)} <= ?", cur_month_id])
    @month_id = cur_month.id
    
    @report_description = "Summary of #{@ministry_name} during #{cur_month.description}"
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

    setup_campus_ids
    @campus_stats = get_campus_stats_hash_for_date_range(first_end_date, last_end_date, @campuses)
    @campus_prcs = get_campus_prcs_hash_for_date_range(first_end_date, last_end_date, @campuses)

    @years = Year.all(:conditions => ["#{_(:id, :year)} <= ?",current_year_id]).select{|y| y.months.any? && y.months.first.weeks.any?}

    @report_description = "Campuses under #{@ministry_name} during #{year.description}"
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

    setup_campus_ids
    @campus_stats = get_campus_stats_hash_for_date_range(first_end_date, last_end_date, @campuses)
    @campus_prcs = get_campus_prcs_hash_for_date_range(first_end_date, last_end_date, @campuses)

    # ensures that semesters that haven't occurred yet aren't listed
    cur_semester_id = Month.find_semester_id(@cur_month)
    @semesters = Semester.find(:all, :conditions => ["#{_(:id, :semester)} <= ?",cur_semester_id])

    @report_description = "Campuses under #{@ministry_name} during #{semester.description}"
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

    setup_campus_ids
    @campus_stats = get_campus_stats_hash_for_date_range(first_week_end_date, last_week_end_date, @campuses)
    @campus_prcs = get_campus_prcs_hash_for_date_range(first_week_end_date, last_week_end_date, @campuses)


    @weeks = Week.find_weeks_in_month(@month_id)
    @months = Month.find(:all, :conditions => ["#{_(:id, :month)} <= ?", @cur_month_id])

    @report_description = "Campuses under #{@ministry_name} during #{month.description}"
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

    setup_campus_ids
    @campus_stats = get_campus_stats_hash_for_date_range(first_week_end_date, last_week_end_date, @campuses)
    @campus_prcs = get_campus_prcs_hash_for_date_range(first_week_end_date, last_week_end_date, @campuses)


    @weeks = Week.all(:conditions => ["#{_(:end_date, :week)} <= ?", cur_week.end_date], :order => :week_endDate)

    @report_description = "Campuses under #{@ministry_name} during the week ending on #{week.end_date}"
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
  

  def get_current_year
    @current_year ||= Month.find(:first, :conditions => {:month_calendaryear => Time.now.year, :month_number => Time.now.month}).year
  end

  def get_current_semester
    @current_semester ||= Month.find(:first, :conditions => {:month_calendaryear => Time.now.year, :month_number => Time.now.month}).semester
  end

  def get_current_month
    @current_month ||= Month.find(:first, :conditions => {:month_calendaryear => Time.now.year, :month_number => Time.now.month})
  end
  
  def get_current_week
    if @current_week.nil?
      today = "#{Time.now.year()}-#{Time.now.month()}-#{Time.now.day()}"
      @current_week = Week.all(:conditions => ["#{_(:end_date, :week)} >= ?", today], :order => "week_endDate asc").first
    end
    @current_week
  end

  #getting the stats period to work with, from the session or from the current time
  def get_current_stats_period_id
    if @current_stats_period_id.nil?
      case @stats_time
        when 'year'
          current_year = get_current_year
      
          session[:stats_year] = params[:year] if params[:year].present?
          session[:stats_year] = current_year.id unless session[:stats_year].present?
          @current_stats_period_id = session[:stats_year]
        when 'semester'
          current = get_current_semester
      
          session[:stats_semester] = params[:semester] if params[:semester].present?
          session[:stats_semester] = current.id unless session[:stats_semester].present?
          @current_stats_period_id = session[:stats_semester]
        when 'month'
          current = get_current_month
      
          session[:stats_month] = params[:month] if params[:month].present?
          session[:stats_month] = current.id unless session[:stats_month].present?
          @current_stats_period_id = session[:stats_month]
        when 'week'
          cur_week = get_current_week
      
          session[:stats_week] = params[:week] if params[:week].present?
          session[:stats_week] = cur_week.id unless session[:stats_week].present?        
          @current_stats_period_id = session[:stats_week]
      end
    end
    @current_stats_period_id
  end

  def setup_selected_time_tab
    case @stats_time
      when 'year'
        @year_id = get_current_stats_period_id
        @years = Year.all(:conditions => ["#{_(:id, :year)} <= ?", get_current_year.id])
        @tab_select_partial = "select_year"
        
      when 'semester'
        @semester_id = get_current_stats_period_id
        @semesters = Semester.find(:all, :conditions => ["#{_(:id, :semester)} <= ?",get_current_semester.id])
        @tab_select_partial = "select_semester"
        
      when 'month'
        @month_id = get_current_stats_period_id
        @months = Month.find(:all, :conditions => ["#{_(:id, :month)} <= ?", get_current_month.id])
        @tab_select_partial = "select_month"

      when 'week'
        @week_id = get_current_stats_period_id
        @weeks = Week.all(:conditions => ["#{_(:end_date, :week)} <= ?", get_current_week.end_date], :order => :week_endDate)
        @tab_select_partial = "select_week"
        
    end
  end

  def get_current_stats_period
    if @current_stats_period.nil?
      case @stats_time
        when 'year'
          @current_stats_period = Year.find(get_current_stats_period_id)
          
        when 'semester'
          @current_stats_period = Semester.find(get_current_stats_period_id)
  
        when 'month'
          @current_stats_period = Month.find(get_current_stats_period_id)
  
        when 'week'
          @current_stats_period = Week.find(get_current_stats_period_id)
      end        
    end
    @current_stats_period
  end

  def setup_selected_period_for_drilldown
    @period = get_current_stats_period
  end

  def setup_report_description
    case @report_type
      when 'comp'
        report_name = 'Compliance report for '
      when 'hpctc'
        report_name = 'How people came to Christ for '
      when 'story'
        report_name = 'Salvation Story Synopses for '
      when 'c4c'
        if @report_scope == SUMMARY
          report_name = 'Summary for '
        end
    end

    if @report_scope == CAMPUS_DRILL_DOWN
        report_name = 'Campus drill down of '
    elsif @report_scope == STAFF_DRILL_DOWN
      report_name = 'Staff drill down of '
    end
    
    case @stats_time
      when 'year'
        period_description = get_current_stats_period.description
          
      when 'semester'
        period_description = get_current_stats_period.description

      when 'month'
        period_description = get_current_stats_period.description

      when 'week'
        period_description = "the week ending on #{get_current_stats_period.end_date}"
        
    end   
    @report_description = "#{report_name}#{@ministry_name} during #{period_description}"
  end

  def setup_campus_ids
    @campus_ids ||= @stats_ministry.unique_campuses.collect { |c| c.id }    
    @campuses ||= @campus_ids.collect{ |c_id| Campus.find(c_id) }.sort { |x, y| x.campus_desc <=> y.campus_desc } if @report_scope == CAMPUS_DRILL_DOWN
  end
  #----------------------------------------------------------------------------------------
  # Stuff for Staff drill down
    
  def staff_drill_down_hash(staff)
    { :person_id => staff[:person_id], :name => "#{staff[:person_fname].capitalize} #{staff[:person_lname].capitalize}" }
  end
    
  def collect_staff_for_ministry(ministry)
    staff_collection = []
    if authorized?('view_other_staffs', 'stats')
      staff_collection = ministry.staff.collect{|s| staff_drill_down_hash(s) }
    else
      if ministry.staff.include?(@me)
        staff_collection = [staff_drill_down_hash(@me)]
      end
    end
    staff_collection
  end
    
  def get_staffs_persons_for_ministry(ministry)
    (collect_staff_for_ministry(ministry) + ministry.children.collect{|m| get_staffs_persons_for_ministry(m)}).flatten.sort{|a, b| a[:name] <=> b[:name]}.uniq
  end

  def get_staff_ids_for_persons_hash(persons_hash)
    persons_hash.each do|s| 
      result = CimHrdbStaff.find(:first, :conditions => { :person_id => s[:person_id] })
      s[:staff_id] = result.nil? ? nil : result[:staff_id]
    end    
  end
  
  def setup_staffs_for_staff_drilldown(report_scope, ministry)
    @staffs = []
    if report_scope == STAFF_DRILL_DOWN
      persons_hash = get_staffs_persons_for_ministry(ministry)
      get_staff_ids_for_persons_hash(persons_hash)
      @staffs = persons_hash
    end
  end
  #----------------------------------------------------------------------------------------
  
  def add_report_if_authorized(report_symbol)
    permission_details = report_permissions[report_symbol][:reading]
    if permission_details && authorized?(permission_details[:action], permission_details[:controller])#, @stats_ministry)
      @reports_to_show += [report_symbol]
    end
  end
  
  def setup_reports_to_show
    @reports_to_show = []
    @show_non_database = false
    case @report_type
      when 'p2c'
        add_report_if_authorized(:p2c_report)
      when 'ccci'
        add_report_if_authorized(:ccci_report)
        @show_non_database = true
    end
    if @reports_to_show.empty?
        add_report_if_authorized(:weekly_report)
        add_report_if_authorized(:indicated_decisions_report)
        if @report_scope == SUMMARY
          add_report_if_authorized(:monthly_report) if ['year', 'semester'].include?(@stats_time)
          add_report_if_authorized(:semester_report) if @stats_time == 'year'
        end
    end
  end

  def hide_time_tabs(tab_symbols_array)
    tab_symbols_array.each { | tab | @hide_tab[tab] = true }
  end

  def setup_time_tabs_visibility
    @time_tabs = [:week, :month, :semester, :year]
    @hide_tab = { :week => false,
                  :month => false,
                  :semester => false,
                  :year => false }
    
    hide_time_tabs([:week]) if @stats_summary
    
    case @report_type
      when 'ccci' 
        hide_time_tabs([:week])
        hide_time_tabs([:month]) if @report_scope == SUMMARY
      when 'p2c' 
        hide_time_tabs([:week, :month])
      when 'comp' 
        hide_time_tabs([:week, :month, :year])
      when 'story'
        hide_time_tabs([:week, :month, :semester])
      when 'hpctc'
        hide_time_tabs([:week, :month, :semester])
      end
   
  end

  def show_scope_radio(scope)
    case scope[:show]
      when :yes
        return true
      when :if_more_than_one_campus
        return !@oneCampusMinistry
      end
  end

  def get_initialized_scope_radio(key, scope)
    the_key = :"#{key}"
    {
      :order => scope[:order],
      :checked => @report_scope == key ? true : false, 
      :disabled => false, 
      :value => key,
      :label => scope[:label], 
      :title => scope[:title].gsub('[MINISTRY_NAME]', "#{@ministry_name}"),
      :show => show_scope_radio(scope) && available_scopes.include?(the_key)
    }
  end

  def setup_report_scope_radios
    @scope_radios = []
    report_scopes.each { |k,v| @scope_radios << get_initialized_scope_radio(k.to_s ,v) }
    @scope_radios = @scope_radios.sort {|x,y| x[:order] <=> y[:order] }
  end

  def setup_summary_drilldown_radio_visibility
    setup_report_scope_radios
    @hide_radios = false
    @hide_radios = true if available_scopes.length <= 1
    @hide_radios = true if !is_ministry_admin && !@drillDownAccess
    
    if @hide_radios || !(available_scopes.include?(:"#{@report_scope}"))
      new_scope = SUMMARY
      new_scope = available_scopes[0].to_s if available_scopes.length == 1
      session[:stats_summary] = new_scope == SUMMARY ? DEFAULT_SUMMARY : false  
      @stats_summary = new_scope == SUMMARY ? true : false
      @report_scope = new_scope
    end
  end

  def check_stats_time_availability
    setup_time_tabs_visibility
    while @hide_tab[:"#{@stats_time}"] && @stats_time != @time_tabs.last.to_s
      @time_tabs.each do |t|
        if t.to_s == @stats_time
          @stats_time = @time_tabs[@time_tabs.index(t) + 1].to_s
          break
        end
      end
    end
    while @hide_tab[:"#{@stats_time}"] && @stats_time != @time_tabs.first.to_s
      @time_tabs.each do |t|
        if t.to_s == @stats_time
          @stats_time = @time_tabs[@time_tabs.index(t) - 1].to_s
          break
        end
      end
    end
  end

  def setup_period_dropdown(current_period)
    period_dropdown = nil
    case @stats_time
      when 'year'
        period_dropdown = @years = Year.all(:conditions => ["#{_(:id, :year)} <= ?",current_period.id])
      when 'semester'
        period_dropdown = @semesters = Semester.find(:all, :conditions => ["#{_(:id, :semester)} <= ?",current_period.id], :order => :semester_startDate)
      when 'month'
        period_dropdown = @months = Month.find(:all, :conditions => ["#{_(:id, :month)} <= ?", current_period.id])
      when 'week'
        period_dropdown = @weeks = Week.all(:conditions => ["#{_(:end_date, :week)} <= ?", current_period.end_date], :order => :week_endDate)
    end
    period_dropdown
  end

  def current_report_type
    report_types[:"#{@report_type}"]
  end
  
  def available_scopes
    current_report_type[:scopes]
  end
  
end
