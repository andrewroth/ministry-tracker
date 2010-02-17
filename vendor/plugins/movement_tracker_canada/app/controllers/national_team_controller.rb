class NationalTeamController < ApplicationController
  unloadable
  
  # how_people_prayed_to_receive_christ action
  def how_people_prayed_to_receive_christ
    
    # find the current month
    curMonth = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    # find the current year id
    current_id = Month.find_year_id(curMonth)
    
    if params[:year].nil? # if no parameters select the current year
      @yearID = current_id
      @yearSelected = Year.find_year_description(@yearID)
    else # else set the current year to the parameter
      @yearSelected = params[:year]['year']
      @yearID = Year.find_year_id(@yearSelected)
    end
    
    # Initialize Variables Used by View
    
    @years = Year.find_years(current_id)
    
    # calculate the totals and percentages of the various indicated decisions methods
    calculations(@yearID) 
    
  end # end of how_people_prayed_to_receive_christ action
  
  # indicated_decisions action
  def indicated_decisions
    
    # find the current month    
    curMonth = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    
    if params[:semester].nil? # if no parameters select the current semester
      @semesterID = Month.find_semester_id(curMonth)
      @semesterSelected = Semester.find_semester_description(@semesterID)
    else # else set the semester to the parameter
      @semesterSelected = params[:semester]['semester']
      @semesterID = Semester.find_semester_id(@semesterSelected)  
    end
    
    # Initialize Variables Used by View
    
    @campuses = Campus.find_campuses()
    
    # the code below ensures that semesters that haven't occurred yet aren't listed    
    curID = Month.find_semester_id(curMonth)
    @semesters = Semester.find_semesters(curID)
    @curSemester = Semester.find_semester_description(curID)
    
  end # end of indicated_decisions action
  
  # calculations method
  def calculations(yearID)
    @methods = Array.new(Prcmethod.last.id+1){0}
    @completed = Array.new(Prcmethod.last.id+1){0}

    semesters = Semester.find_semesters_by_year(yearID) # find all semesters in a year
    year_start = Date.parse_date( semesters.first.semester_startDate )
    year_end   = Date.parse_date( Semester.find(semesters.last.id + 1).semester_startDate )

    prcs = Prc.all(:conditions => ["#{_(:prc_date, :prc)} >= ? and #{_(:prc_date, :prc)} < ?", year_start, year_end]) # all prcs in the year
    @total = prcs.size

    prcs.each do |prc|
      @methods[prc.prcMethod_id] += 1
      @completed[prc.prcMethod_id] += 1 if prc.prc_7upCompleted == 1
    end

  end # end of calculations method
  
end
