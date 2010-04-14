class StatsController < ApplicationController
  unloadable

  skip_before_filter :authorization_filter, :only => [:campuses_collection_select]

  def index
    
#    @national_access = authorized?(:how_people_prayed_to_receive_christ, :national_team) ? true : false
#    @regional_access = authorized?(:summary_by_week, :regional_team) ? true : false
#    @campusdirector_access = authorized?(:monthly_summary_by_campus, :campus_directors) ? true : false
#    @allstaff_access = authorized?(:year_summary, :all_staff) ? true : false
    
  end


  def campuses_collection_select
    ministry = Ministry.find(params[:ministry])
    campuses = ministry.unique_campuses.sort { |x, y| x.campus_desc <=> y.campus_desc }

    if campuses.size > 0
      @options = campuses.size > 1 ? [{:key => "0", :value => "Report all campuses under #{ministry.name}"}] : []

      campuses.each do |campus|
        @options << { :key => campus.id, :value => campus.campus_desc }
      end
    else
      @options = [{:key => "-1", :value => "There are no campuses under #{ministry.name}"}]
    end

    @form_name = 'semester'
    @select_value = 'campus_id'
    @selected_key = params[:campus_id]

    render :partial => "collection_select"
  end


  def semester_at_a_glance

    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"

    @ministries = my_ministries_for_stats.sort { |x, y| x.name <=> y.name }

    if params[:report].nil?

      @ministry_id = get_ministry.id
      @semester_id = Month.find_semester_id(cur_month)
      @campus_id = "0"

    else # set the appropriate variables to the parameters

      @ministry_id = params[:report]['ministry']
      @campus_id = params[:report]['campus_id']
      @semester_id = Semester.find_semester_id(params[:report]['semester'])

      @staff_id = authorized?(:index, :stats) ? nil : @me.cim_hrdb_staff.id
      @staff = WeeklyReport.find_staff(@semester_id, @campus_id, @staff_id)

      @weeks = Week.find_weeks_in_semester(@semester_id)
      @months = Month.find_months_by_semester(@semester_id)

      flash[:notice] = @staff.size == 0 ? "Sorry, no stats were found for your selection!" : nil
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

      @ministry_id = get_ministry.id
      @semester_id = Month.find_semester_id(cur_month)

    else
      @ministry_id = params[:report]['ministry']
      @ministry_selected = Ministry.find(@ministry_id)
      
      @semester_id = Semester.find_semester_id(params[:report]['semester'])

      @campuses = @ministry_selected.unique_campuses.sort { |x, y| x.campus_desc <=> y.campus_desc }
      
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
      @ministry_id = get_ministry.id

      @semester_id = Month.find_semester_id(@cur_month)
      @semester_selected = Semester.find_semester_description(@semester_id)
    else
      @ministry_id = params[:report]['ministry']
      @ministry_selected = Ministry.find(@ministry_id)
      
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
      @ministry_id = get_ministry.id

      @month_selected = @cur_month
    else
      @ministry_id = params[:report]['ministry']
      @ministry_selected = Ministry.find(@ministry_id)
      
      @month_selected = params[:report]['month']
    end

    # Initialize Variables Used by View

    @month_id = Month.find_month_id(@month_selected)
    @weeks = Week.find_weeks_in_month(@month_id)

    # the code below ensures that months that haven't occurred yet aren't listed
    cur_id = Month.find_month_id(@cur_month)
    @months = Month.find_months(cur_id)

  end


  private

  def my_ministries_for_stats
    unless is_ministry_admin
      @me.ministries_involved_in_with_children(::MinistryRole::ministry_roles_that_grant_stats_access)
    else
      ::Ministry.first.myself_and_descendants
    end
  end

end
