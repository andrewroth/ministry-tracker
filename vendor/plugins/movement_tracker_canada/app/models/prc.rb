class Prc < ActiveRecord::Base
  
  load_mappings
  belongs_to :campus, :class_name => 'Campus', :foreign_key => _(:id, :campus)
  belongs_to :prcMethod, :class_name => 'Prcmethod', :primary_key => _(:id, :prcmethod), :foreign_key => _(:id, :prcmethod)
  belongs_to :semester, :class_name => 'Semester', :primary_key => _(:id, :semester), :foreign_key => _(:id, :semester)
  
  # This method will return the amount of indicated decisions that occurred between a given start and end date in a given region
  def self.count_by_date(start_date,end_date,region_id)
    # national team stats are not included, so if the region_id is the national_region then it means total all other regions
    if region_id == national_region
      result = self.count(:all, :joins => :campus, :conditions => ["#{_(:region_id, :campus)} != ? AND #{_(:date)} <= ? AND #{_(:date)} > ?",region_id,end_date,start_date])
    else # else just find the stats associated with the given region
      result = self.count(:all, :joins => :campus, :conditions => ["#{_(:region_id, :campus)} = ? AND #{_(:date)} <= ? AND #{_(:date)} > ?",region_id,end_date,start_date])
    end
    result
  end
  
  # This method will return the amount of indicated decisions that occurred between a given start and end date associated with a given campus id
  def self.count_by_campus(start_date,end_date,campus_id)
    count(:all, :conditions => ["#{_(:campus_id)} = ? AND #{_(:date)} <= ? AND #{_(:date)} > ?",campus_id,end_date,start_date])
  end
  
  # This method will return the amount of indicated decisions that occurred during a given semester id and in a given region
  def self.count_by_semester(semester_id,region_id)
    # national team stats are not included, so if the region_id is the national_region then it means total all other regions
    if region_id == national_region
      result = self.count(:all, :joins => :campus, :conditions => ["#{_(:region_id, :campus)} != ? AND #{_(:semester_id)} = ?",region_id,semester_id])
    else # else just find the stats associated with a given region
      result = self.count(:all, :joins => :campus, :conditions => ["#{_(:region_id, :campus)} = ? AND #{_(:semester_id)} = ?",region_id,semester_id])
    end
    result
  end
  
  # This method will return the amount of indicated decisions during a given semester and associated with a given campus id
  def self.count_by_semester_and_campus(semester_id,campus_id)
    count(:all, :joins => :campus, :conditions => ["#{__(:id, :campus)} = ? AND #{_(:semester_id)} = ?",campus_id,semester_id])
  end
  
  # This method will insert a new indicated decision
  def self.submit_decision(semesterID, campusID, methodID, date, notes, name, witness, believer)
    create(_(:semester_id) => semesterID, _(:campus_id) => campusID, _(:method_id) => methodID, _(:date) => date, _(:notes) => notes, _(:first_name) => name, _(:witness_name) => witness, _(:integrated_believer) => believer)
  end
  
  # This method will update a given indicated decision
  def self.update_decision(id,semesterID, campusID, methodID, date, notes, name, witness, believer)
    update(id,_(:semester_id) => semesterID, _(:campus_id) => campusID, _(:method_id) => methodID, _(:date) => date, _(:notes) => notes, _(:first_name) => name, _(:witness_name) => witness, _(:integrated_believer) => believer)
  end
  
  # This method will return all the indicated decisions associated with a semester and campus
  def self.find_by_semester_and_campus(semester_id,campus_id)
    find(:all, :joins => :campus, :conditions => ["#{__(:id, :campus)} = ? AND #{_(:semester_id)} = ?",campus_id,semester_id])
  end
  
  # This method will return the indicated decision associated with the given id
  def self.find_by_id(id)
    find(:first, :conditions => {_(:id) => id})
  end
  
  # This method will delete the indicated decision associated with the given id
  def self.delete_by_id(id)
    delete(id)
  end
  
end
