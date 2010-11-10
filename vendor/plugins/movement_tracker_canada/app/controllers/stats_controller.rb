require "date"
class StatsController < ApplicationController
  unloadable

  skip_before_filter :authorization_filter, :only => [:select_report, :ie_warning]


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
  COMPLIANCE_REPORT = 'comp'
  PERSONAL_STATS = 'perso'


  def index
    session[:stats_ignore_ie_warning] = true if params['withie'] == '1' if params['withie'].present?
    session[:stats_ministry_id] = get_ministry.id unless session[:stats_ministry_id].present?
    session[:stats_time] = DEFAULT_REPORT_TIME unless session[:stats_time].present?
    session[:stats_report_type] = DEFAULT_REPORT_TYPE unless session[:stats_report_type].present?
    session[:stats_report_scope] = DEFAULT_REPORT_SCOPE unless session[:stats_report_scope].present?
    session[:stats_ignore_ie_warning] = false unless session[:stats_ignore_ie_warning].present?

    user_agent = request.env['HTTP_USER_AGENT'].downcase
    if user_agent =~ /msie/i && !session[:stats_ignore_ie_warning]
      redirect_to(:action => "ie_warning")
    end

    setup_stats_report_from_session
  end
  
  def ie_warning
    #not much to do in here (in fact, nothing!)
  end

  def select_report
    session[:stats_ministry_id] = params['ministry'] if params['ministry'].present?
    session[:stats_time] = params['time']
    session[:stats_report_type] = params['report_type'] if params['report_type'].present?
    session[:stats_report_scope] = params['report_scope'] if params['report_scope'].present?

    setup_stats_report_from_session

    case @report_type
      when COMPLIANCE_REPORT
        setup_compliance_report
      when 'hpctc'
        setup_how_people_came_to_christ_report
      when 'story'
        setup_story_report
      when 'annual_goals'
        setup_annual_goals_report
      when PERSONAL_STATS
        setup_personal_report
      else
        # c4c, p2c and ccci are all handled here:
        select_c4c_report
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def select_c4c_report
    case @report_scope
      when SUMMARY
        setup_summary
      when CAMPUS_DRILL_DOWN
        setup_campus_drill_down
       when STAFF_DRILL_DOWN
        setup_staff_drill_down
      end
  end

  def my_ministries_for_stats(action)
    unless is_ministry_admin
      @me.ministries_involved_in_with_children(::MinistryRole::ministry_roles_that_grant_access("stats", action))
    else
      ::Ministry.first.myself_and_descendants
    end
  end


  def setup_stats_report_from_session
    @hide_ministry_treeview = false
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

    @stats_time = session[:stats_time]
    @report_type = session[:stats_report_type] 
    @report_scope = session[:stats_report_scope]
    
    setup_summary_drilldown_radio_visibility
    check_stats_time_availability
    setup_reports_to_show

    @scope_radio_selected_id = report_scopes[:"#{@report_scope}"][:radio_id]
    
    @show_additional_report_links = (authorized?("how_people_came_to_christ", "stats")) ? true : false
    @show_ministries_under = authorized?("view_ministries_under", "stats")
 
    @selected_results_div_id = "stats#{@stats_time.capitalize}Results"
    @selected_time_tab_id = @stats_time
  end


  def setup_annual_goals_report
    setup_campus_ids
    setup_selected_time_tab
    setup_selected_period_for_drilldown
    setup_report_description

    year = Year.find(@year_id)
    month_ids = year.months.collect {|m| m.id}
    semester_ids = year.semesters.collect {|s| s.id}
    
    week_ids = []
    year.months.each do |m|
      week_ids << m.weeks.collect {|w| w.id}
    end
    week_ids.flatten!



    annual_goals_sum = AnnualGoalsReport.first(:select => "
      sum(#{AnnualGoalsReport.table_name}.#{_(:students_in_ministry, :annual_goals_report)}) as students_in_ministry,
      sum(#{AnnualGoalsReport.table_name}.#{_(:spiritual_multipliers, :annual_goals_report)}) as spiritual_multipliers,
      sum(#{AnnualGoalsReport.table_name}.#{_(:first_years, :annual_goals_report)}) as first_years,
      sum(#{AnnualGoalsReport.table_name}.#{_(:total_went_to_summit, :annual_goals_report)}) as total_went_to_summit,
      sum(#{AnnualGoalsReport.table_name}.#{_(:total_went_to_wc, :annual_goals_report)}) as total_went_to_wc,
      sum(#{AnnualGoalsReport.table_name}.#{_(:total_went_on_project, :annual_goals_report)}) as total_went_on_project,
      sum(#{AnnualGoalsReport.table_name}.#{_(:spiritual_conversations, :annual_goals_report)}) as spiritual_conversations,
      sum(#{AnnualGoalsReport.table_name}.#{_(:gospel_presentations, :annual_goals_report)}) as gospel_presentations,
      sum(#{AnnualGoalsReport.table_name}.#{_(:holyspirit_presentations, :annual_goals_report)}) as holyspirit_presentations,
      sum(#{AnnualGoalsReport.table_name}.#{_(:indicated_decisions, :annual_goals_report)}) as indicated_decisions,
      sum(#{AnnualGoalsReport.table_name}.#{_(:followup_completed, :annual_goals_report)}) as followup_completed,
      sum(#{AnnualGoalsReport.table_name}.#{_(:large_event_attendance, :annual_goals_report)}) as large_event_attendance",
      :conditions => ["#{_(:campus_id, :annual_goals_report)} in (?) AND #{_(:year_id, :annual_goals_report)} = ?", @campus_ids, year.id])

    @annual_goals_sum = ActiveSupport::OrderedHash.new
    @annual_goals_sum[:students_in_ministry] = annual_goals_sum["students_in_ministry"]
    @annual_goals_sum[:spiritual_multipliers] = annual_goals_sum["spiritual_multipliers"]
    @annual_goals_sum[:first_years] = annual_goals_sum["first_years"]
    @annual_goals_sum[:total_went_to_summit] = annual_goals_sum["total_went_to_summit"]
    @annual_goals_sum[:total_went_to_wc] = annual_goals_sum["total_went_to_wc"]
    @annual_goals_sum[:total_went_on_project] = annual_goals_sum["total_went_on_project"]
    @annual_goals_sum[:spiritual_conversations] = annual_goals_sum["spiritual_conversations"]
    @annual_goals_sum[:gospel_presentations] = annual_goals_sum["gospel_presentations"]
    @annual_goals_sum[:holyspirit_presentations] = annual_goals_sum["holyspirit_presentations"]
    @annual_goals_sum[:indicated_decisions] = annual_goals_sum["indicated_decisions"]
    @annual_goals_sum[:followup_completed] = annual_goals_sum["followup_completed"]
    @annual_goals_sum.each do |key,goal|
      @annual_goals_sum[key] = 0 if goal.blank?
    end

    
    @monthly_sum = MonthlyReport.first(:select => "
      sum(#{MonthlyReport.table_name}.#{_(:number_frosh_involved, :monthly_report)}) as number_frosh_involved,
      sum(#{MonthlyReport.table_name}.#{_(:event_spiritual_conversations, :monthly_report)}) as event_spiritual_conversations,
      sum(#{MonthlyReport.table_name}.#{_(:event_gospel_prensentations, :monthly_report)}) as event_gospel_prensentations,
      sum(#{MonthlyReport.table_name}.#{_(:media_spiritual_conversations, :monthly_report)}) as media_spiritual_conversations,
      sum(#{MonthlyReport.table_name}.#{_(:media_gospel_prensentations, :monthly_report)}) as media_gospel_prensentations,
      sum(#{MonthlyReport.table_name}.#{_(:total_core_students, :monthly_report)}) as total_core_students,
      sum(#{MonthlyReport.table_name}.#{_(:total_spiritual_multipliers, :monthly_report)}) as total_spiritual_multipliers,
      sum(#{MonthlyReport.table_name}.#{_(:total_integrated_new_believers, :monthly_report)}) as followup_completed",
      :conditions => ["#{_(:campus_id, :monthly_report)} in (?) AND #{_(:month_id, :monthly_report)} in (?)", @campus_ids, month_ids])

    @semester_sum = SemesterReport.first(:select => "
      sum(#{SemesterReport.table_name}.#{_(:total_students_to_summit, :semester_report)}) as total_students_to_summit,
      sum(#{SemesterReport.table_name}.#{_(:total_students_to_wc, :semester_report)}) as total_students_to_wc,
      sum(#{SemesterReport.table_name}.#{_(:total_students_to_project, :semester_report)}) as total_students_to_project",
      :conditions => ["#{_(:campus_id, :semester_report)} in (?) AND #{_(:semester_id, :semester_report)} in (?)", @campus_ids, semester_ids])

    @weekly_sum = WeeklyReport.first(:select => "
      sum(#{WeeklyReport.table_name}.#{_(:spiritual_conversations, :weekly_report)}) as spiritual_conversations,
      sum(#{WeeklyReport.table_name}.#{_(:spiritual_conversations_student, :weekly_report)}) as spiritual_conversations_student,
      sum(#{WeeklyReport.table_name}.#{_(:gospel_presentations, :weekly_report)}) as gospel_presentations,
      sum(#{WeeklyReport.table_name}.#{_(:gospel_presentations_student, :weekly_report)}) as gospel_presentations_student,
      sum(#{WeeklyReport.table_name}.#{_(:holyspirit_presentations, :weekly_report)}) as holyspirit_presentations,
      sum(#{WeeklyReport.table_name}.#{_(:holyspirit_presentations_student, :weekly_report)}) as holyspirit_presentations_student",
      :conditions => ["#{_(:campus_id, :weekly_report)} in (?) AND #{_(:week_id, :weekly_report)} in (?)", @campus_ids, week_ids])

    @prc_sum = 0
    campuses = Campus.all(:conditions => ["#{_(:id, :campus)} in (?)", @campus_ids])
    semester_ids.each do |sid|
      @prc_sum += Prc.count_by_semester_and_campuses(sid, campuses)
    end

    @annual_goals_progress = {}
    @annual_goals_progress[:students_in_ministry] = @monthly_sum["total_core_students"].to_i
    @annual_goals_progress[:spiritual_multipliers] = @monthly_sum["total_spiritual_multipliers"].to_i
    @annual_goals_progress[:first_years] = @monthly_sum["number_frosh_involved"].to_i
    @annual_goals_progress[:total_went_to_summit] = @semester_sum["total_students_to_summit"].to_i
    @annual_goals_progress[:total_went_to_wc] = @semester_sum["total_students_to_wc"].to_i
    @annual_goals_progress[:total_went_on_project] = @semester_sum["total_students_to_project"].to_i
    
    @annual_goals_progress[:spiritual_conversations] = @weekly_sum["spiritual_conversations"].to_i + @weekly_sum["spiritual_conversations_student"].to_i
    @annual_goals_progress[:gospel_presentations] = @weekly_sum["gospel_presentations"].to_i + @weekly_sum["gospel_presentations_student"].to_i
    @annual_goals_progress[:holyspirit_presentations] = @weekly_sum["holyspirit_presentations"].to_i + @weekly_sum["holyspirit_presentations_student"].to_i
    @annual_goals_progress[:indicated_decisions] = @prc_sum.to_i
    @annual_goals_progress[:followup_completed] = @monthly_sum["followup_completed"].to_i

    @annual_goals_progress.each do |key,goal|
      @annual_goals_progress[key] = 0 if goal.blank?
    end




    @results_partial = "annual_goals"
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

    date_start = nil
    date_end = nil

    # find the prc ('indicated decisions') data to display
    case @stats_time
      when 'year'
        semesters = Semester.find_semesters_by_year(@year_id) # find all semesters in a year
        date_start = Date.parse_date( semesters.first.semester_startDate )
        date_end   = Date.parse_date( Semester.find(semesters.last.id + 1).semester_startDate )
        
      when 'semester'
        semester = Semester.find(@semester_id)
        date_start = semester.start_date
        date_end   = Date.parse_date( semester.end_date )

    end

    @prcs = Prc.all(:conditions => ["#{_(:prc_date, :prc)} >= ? and #{_(:prc_date, :prc)} < ? and #{_(:campus_id, :prc)} in (?)", date_start, date_end, @campus_ids], :order => 'prc_date ASC')

    @results_partial = "salvation_story_synopses"
  end


  def setup_summary
    setup_selected_period_for_summary
    setup_campus_ids
    setup_selected_time_tab
    setup_report_description
    @results_partial = "summary"
  end

  def setup_personal_report
    @hide_ministry_treeview = true
    @stats_ministry = Ministry.root
    case @report_scope
      when SUMMARY
        setup_selected_period_for_summary
        setup_staffs_for_staff_drilldown(@report_scope)
        setup_selected_time_tab
        setup_report_description
        @results_partial = "summary"
      when CAMPUS_DRILL_DOWN
        setup_selected_period_for_drilldown    
        setup_selected_time_tab
        setup_staffs_for_staff_drilldown(@report_scope)
        setup_campus_ids
        setup_report_description
        @results_partial = "campus_drill_down"
    end
    
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

  def get_underneat_periods(period)
    periods = []
    case period.class.name
      when "Year"
        periods = period.semesters
      when "Semester"
        periods = period.months
      when "Month"
        periods = period.weeks
    end
    periods
  end

  def setup_selected_period_for_drilldown
    @period = get_current_stats_period
  end

  def setup_selected_period_for_summary
    @period = get_current_stats_period
    @periods = get_underneat_periods(@period)
  end

  def setup_report_description
    ministry_name = @ministry_name
    
    fname = @me.person_fname
    lname = @me.person_lname
    ministry_name = "#{fname} #{lname}'s stats" if @report_type == PERSONAL_STATS
    
    case @report_type
      when COMPLIANCE_REPORT
        report_name = "Compliance report for #{ministry_name}"
      when 'hpctc'
        report_name = "How people came to Christ for #{ministry_name}"
      when 'story'
        report_name = "Salvation Story Synopses for #{ministry_name}"
      when 'annual_goals'
        report_name = "Goals for #{ministry_name}"
      when PERSONAL_STATS
        fname = @me.person_fname
        lname = @me.person_lname
        report_name = "#{fname} #{lname}'s stats "
        if @report_scope == SUMMARY
          report_name = "Summary of #{ministry_name}"
        end
      when 'c4c'
        if @report_scope == SUMMARY
          report_name = "Summary of #{ministry_name}"
        end
    end

    if @report_scope == CAMPUS_DRILL_DOWN
        report_name = "Campus drill down of #{ministry_name}"
    elsif @report_scope == STAFF_DRILL_DOWN
      report_name = "Staff drill down of #{ministry_name}"
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

    @report_description = "#{report_name} during #{period_description}"
  end

  def setup_campus_ids
    
    if @report_type == PERSONAL_STATS
      @campus_ids = WeeklyReport.find(:all, :conditions => {:staff_id => @staff_id}).collect{|wr| wr[:campus_id]}.uniq
    else
      @campus_ids ||= @stats_ministry.unique_campuses.collect { |c| c.id }
    end
    
    @campuses ||= @campus_ids.collect{ |c_id| Campus.find(c_id) }.sort { |x, y| x.campus_desc <=> y.campus_desc } if @report_scope == CAMPUS_DRILL_DOWN
  end
  #----------------------------------------------------------------------------------------
  # Stuff for Staff drill down
    
  def staff_drill_down_hash(staff)
    { :person_id => staff[:person_id], :name => "#{staff[:person_fname].capitalize} #{staff[:person_lname].capitalize}" }
  end
    
  def collect_staff_for_ministry(ministry)
    staff_collection = []
    action = 'view_other_staffs'
    action = 'team_compliance_report' if @report_type == COMPLIANCE_REPORT
    if authorized?(action, 'stats')
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

  def get_staff_id_for_person(person_id)
      result = CimHrdbStaff.find(:first, :conditions => { :person_id => person_id })
      result.nil? ? nil : result[:staff_id]    
  end

  def get_staff_ids_for_persons_hash(persons_hash)
    persons_hash.each do|s| 
      s[:staff_id] = get_staff_id_for_person(s[:person_id])
    end    
  end
  
  def setup_staffs_for_staff_drilldown(report_scope, ministry = nil)
    @staffs = []
    if report_scope == STAFF_DRILL_DOWN
      persons_hash = get_staffs_persons_for_ministry(ministry)
      get_staff_ids_for_persons_hash(persons_hash)
      @staffs = persons_hash
    end
    if @report_type == PERSONAL_STATS
      @staff_id = get_staff_id_for_person(@me.id)
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
      when PERSONAL_STATS
        add_report_if_authorized(:weekly_report)
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
    
    hide_time_tabs([:week]) if @report_scope == SUMMARY
    
    case @report_type
      when 'ccci' 
        hide_time_tabs([:week])
        hide_time_tabs([:month]) if @report_scope == SUMMARY
      when 'p2c' 
        hide_time_tabs([:week, :month])
      when COMPLIANCE_REPORT 
        hide_time_tabs([:week, :month, :year])
      when 'story'
        hide_time_tabs([:week, :month])
      when 'hpctc'
        hide_time_tabs([:week, :month, :semester])
      when 'annual_goals'
        hide_time_tabs([:week, :month, :semester])
      when PERSONAL_STATS
        # no more time tabs to hide
      end
   
  end

  def show_scope_radio(scope)
    case scope[:show]
      when :yes
        return true
      when :if_more_than_one_campus
        return !oneCampusMinistry
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
    
    if @hide_radios || !(available_scopes.include?(:"#{@report_scope}"))
      new_scope = SUMMARY
      new_scope = available_scopes[0].to_s if available_scopes.length == 1
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
    @available_scopes ||= get_available_scopes
  end

  def get_available_scopes
    scopes = current_report_type[:scopes]
    unless @report_type == PERSONAL_STATS || campusDrillDownAccess
      scopes.delete(:campus_drill_down)
    end
    scopes
  end

  def oneCampusMinistry
    @oneCampusMinistry ||= @stats_ministry.unique_campuses.size <= 1 ? true : false
  end

  def campusDrillDownAccess
    @campusDrillDownAccess ||= is_ministry_admin || @me.has_permission_from_ministry_or_higher("drill_down_access", "stats", @stats_ministry)
  end
  
end
