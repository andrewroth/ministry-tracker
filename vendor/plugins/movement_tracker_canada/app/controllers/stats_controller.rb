class StatsController < ApplicationController
  unloadable
  
  def index
    
#    @national_access = authorized?(:how_people_prayed_to_receive_christ, :national_team) ? true : false
#    @regional_access = authorized?(:summary_by_week, :regional_team) ? true : false
#    @campusdirector_access = authorized?(:monthly_summary_by_campus, :campus_directors) ? true : false
#    @allstaff_access = authorized?(:year_summary, :all_staff) ? true : false
    
  end


  def campuses_collection_select
    params.each {|p| puts p.inspect}

    ministry = Ministry.find(params[:ministry])
    campuses = ministry.unique_campuses

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

    render :partial => "collection_select"
  end


  def semester_at_a_glance

    # find the current month
    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"

    if params[:semester].nil?

      @ministry_id = nil
      @semester_id = Month.find_semester_id(cur_month)
      @semester_selected = Semester.find_semester_description(@semester_id)

    else # else set the appropriate variables to the parameters

      @ministry_selected = params[:semester]['ministry']
      @semester_selected = params[:semester]['semester']
      @campus_id = Campus.find_campus_id(@campus_selected)
      @semester_id = Semester.find_semester_id(@semester_selected)

      @staff_id = authorized?(:monthly_summary_by_campus, :campus_directors) ? nil : @me.cim_hrdb_staff.id
      @staff = WeeklyReport.find_staff(@semester_id, @campus_id, @staff_id)

      @weeks = Week.find_weeks_in_semester(@semester_id)
      @months = Month.find_months_by_semester(@semester_id)

    end

    # Initialize Variables Used by View
    @mi = ministry_involvement_granting_authorization(:semester_at_a_glance, :stats)

    @ministries = @mi.ministry.myself_and_descendants
    @campuses = @mi.ministry.unique_campuses


    # the code below ensures that months that haven't occurred yet aren't listed
    cur_id = Month.find_semester_id(cur_month)
    @semesters = Semester.find_semesters(cur_id)
    @cur_semester = Semester.find_semester_description(cur_id)
    
  end

end
