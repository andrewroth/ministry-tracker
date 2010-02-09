class CampusDirectorsController < ApplicationController
  
  # monthly_summary_by_campus
  def monthly_summary_by_campus
    
    if params[:campus].nil? # if no parameters, set the ids to nil
      @campusID = nil 
      @monthID = nil
    else # else set the campus and month to the parameters
      @campusSelected = params[:campus]['campus']
      @monthSelected = params[:campus]['month']
      @campusID = Campus.find_campus_id(@campusSelected) 
      @monthID = Month.find_month_id(@monthSelected)
    end
    
    # Initialize Variables Used by View
    @campuses = Campus.find_campuses()
    
    # find the current month
    @curMonth = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"    
    # the code below ensures that months that haven't occurred yet aren't listed
    curID = Month.find_month_id(@curMonth)
    @months = Month.find_months(curID) 
    
  end # end of monthly_summary_by_campus action
  
end
