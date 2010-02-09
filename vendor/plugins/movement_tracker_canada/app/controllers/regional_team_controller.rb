class RegionalTeamController < ApplicationController
  unloadable
  
  # summary_by_week action
  def summary_by_week
    
    # find the current month
    @curMonth = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    
    if params[:month].nil? # if no parameters select the current month
      @monthSelected = @curMonth
    else # else set the selected month to the parameter
      @monthSelected = params[:month]['month']
    end 
    
    # Initialize Variables Used by View
    
    @monthID = Month.find_month_id(@monthSelected)
    @weeks = Week.find_weeks_in_month(@monthID)
    
    # the code below ensures that months that haven't occurred yet aren't listed    
    curID = Month.find_month_id(@curMonth)
    @months = Month.find_months(curID)
    
  end # end of summary_by_week action
  
  # summay_by_month action
  def summary_by_month
    
    # find the current month
    @curMonth = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    
    if params[:semester].nil? # if no parameters select current semester
      @semesterID = Month.find_semester_id(@curMonth)
      @semesterSelected = Semester.find_semester_description(@semesterID)
    else # else set the selected semester to the parameter
      @semesterSelected = params[:semester]['semester']
      @semesterID = Semester.find_semester_id(@semesterSelected)
    end
    
    # Initialize Variables Used by View
    
    @months = Month.find_months_by_semester(@semesterID)
    
    # the code below ensures that semesters that haven't occurred yet aren't listed    
    curID = Month.find_semester_id(@curMonth)
    @semesters = Semester.find_semesters(curID)
    
  end # end of summay_by_month action
  
  # summary_by_campus action
  def summary_by_campus
    
    # find the current month
    curMonth = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    
    if params[:region].nil? # if no parameters then select the current semester
      @regionID = nil
      @semesterID = Month.find_semester_id(curMonth)
      @semesterSelected = Semester.find_semester_description(@semesterID)
    else # else set the selected semester and region to the parameters
      @semesterSelected = params[:region]['semester']
      @regionSelected = params[:region]['region']
      @semesterID = Semester.find_semester_id(@semesterSelected)
      @regionID = Region.find_region_id(@regionSelected)
      @campuses = Campus.find_campuses_by_region(@regionID)
    end
    
    # Initialize Variables Used by View
    
    country_id = Country.find_country_id("Canada")
    @regions = Region.find_regions(country_id)
    
    # the code below ensures that months that haven't occurred yet aren't listed    
    curID = Month.find_semester_id(curMonth)
    @semesters = Semester.find_semesters(curID)
    @curSemester = Semester.find_semester_description(curID)
    @yearSelected = Year.find_year_description(Semester.find_semester_year(@semesterID))
    
  end # end of summary_by_campus action
  
end
