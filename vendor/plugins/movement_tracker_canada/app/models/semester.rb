class Semester < ActiveRecord::Base
  
  load_mappings
  has_many :prc, :class_name => 'Prc', :primary_key => _(:id), :foreign_key => _(:id)
  
  # This method will return all the semesters associated with a given year id
  def self.find_semesters_by_year(year_id)
    find(:all, :conditions => {_(:year_id) => year_id})
  end
  
  # This method will return the semester id associated with a given description
  def self.find_semester_id(description)
    find(:first, :conditions => {_(:description) => description}).id
  end
  
  # This method will return the semester description associated with a given id
  def self.find_semester_description(id)
    find(:first, :conditions => {_(:id) => id}).description
  end
  
  # This method will return an array of all semesters up to and including the current semester
  def self.find_semesters(current_id)
    find(:all, :conditions => ["#{_(:id)} <= ?",current_id]).collect{ |s| [s.description]}
  end
  
  # This method will return the start date of a given semester id
  def self.find_start_date(semester_id)
    startdate = find(:first, :conditions => {_(:id) => semester_id} ).start_date
  end
  
  # This method will reutrn the end date of a given semester id
  def self.find_end_date(semester_id)
    startdate = find(:first, :conditions => {_(:id) => (semester_id+1)} ).start_date
  end
  
  # This method will return all the semesters associated with a given year
  def self.find_semesters_by_year(year_id)
    find(:all, :conditions => {_(:year_id) => year_id})
  end
  
  # This method will return the year id of a given semester id
  def self.find_semester_year(semester_id)
    find(:first, :conditions => {_(:id) => semester_id})["#{_(:year_id)}"]
  end
  
end
