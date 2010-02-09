class Month < ActiveRecord::Base
  
  load_mappings
  
  # This method will return the start date of a given month id
  def self.find_start_date(month_id)
    result = find(:first, :select => "#{_(:number)}, #{_(:calendar_year)}", :conditions => {_(:id) => month_id} )
    monthNum = result.number
    curYear = result.calendar_year
    # Return it in string format
    startdate = "#{curYear}-#{monthNum}-#{00}" # Note: 00 is what we want.
    startdate
  end
  
  # This method will return the end date of a given month id
  def self.find_end_date(month_id)
    result = find(:first, :select => "#{_(:number)}, #{_(:calendar_year)}", :conditions => {_(:id) => month_id} )
    monthNum = result.number
    curYear = result.calendar_year
    # Return it in string format
    enddate = "#{curYear}-#{monthNum}-#{31}" # Note: 31 is what we want even though not all months have 31 days.
    enddate
  end
  
  # This method will return the year id associated with a given month description
  def self.find_year_id(description)
    find(:first, :conditions => {_(:description) => description})["#{_(:year_id)}"]
  end
  
  # This method will return the month id associated with a given description
  def self.find_month_id(description)
    find(:first, :conditions => {_(:description) => description}).id
  end
  
  # This method will return the month description associated with a given id
  def self.find_month_description(id)
    find(:first, :conditions => {_(:id) => id}).description
  end
  
  # This method will return the semester id associated with a given month description
  def self.find_semester_id(description)
    find(:first, :conditions => {_(:description) => description})["#{_(:semester_id)}"]
  end
  
  # This method will return all the months associated with a given semester id
  def self.find_months_by_semester(semester_id)
    find(:all, :conditions => { _(:semester_id) => semester_id }, :order => _(:id))
  end
  
  # This method will return an array of all the months leading up to and including the current month id
  def self.find_months(current_id)
    find(:all, :conditions => ["#{_(:id)} <= ?",current_id]).collect{ |m| [m.description]}
  end
  
end
