class Week < ActiveRecord::Base
  
  load_mappings
  has_many :weekly_reports, :class_name => 'Weeklyreport', :foreign_key => _(:id)
  belongs_to :campus, :class_name => 'Campus'
  
  # This method will return the given stat total associated with a given staff id
  def self.find_stats_staff(week_id,staff_id,stat)
    week = find(:first, :conditions => {_(:id) => week_id})
    result = week.weekly_reports.find(:all, :conditions => [ "#{_(:staff_id)} = ?", staff_id ])
    result.sum(&stat) # sum the specific stat
  end
  
  # This method will return the given stat total associated with a given week id in a given region
  def self.find_stats_week(week_id,region_id,stat)
    week = find(:first, :conditions => {_(:id) => week_id})
    # national team stats are not included, so if the region_id is the national_region then it means total all other regions
    if region_id == national_region
      result = week.weekly_reports.find(:all, :joins => :campus, :conditions => [ "#{__(:region_id, :campus)} != ?", region_id ])
    else # else just find the stats associated with the given region
      result = week.weekly_reports.find(:all, :joins => :campus, :conditions => [ "#{__(:region_id, :campus)} = ?", region_id ])
    end
    result.sum(&stat) # sum the specific stat
  end
  
  # This method will return the given stat total associated with a given month id in a given region
  def self.find_stats_month(month_id,region_id,stat)
    weeks = find(:all, :conditions => {_(:month_id) => month_id})
    total = 0
    # national team stats are not included, so if the region_id is the national_region then it means total all other regions
    if region_id == national_region
      weeks.each do |week| # for each week find the stat and add it to the total
        result = week.weekly_reports.find(:all, :joins => :campus, :conditions => [ "#{__(:region_id, :campus)} != ?", region_id ])
        total += result.sum(&stat) # sum the specific stat
      end
    else # else just find the stats associated with the given region
      weeks.each do |week| # for each week find the stat and add it to the total
        result = week.weekly_reports.find(:all, :joins => :campus, :conditions => [ "#{__(:region_id, :campus)} = ?", region_id ])
        total += result.sum(&stat) # sum the specific stat
      end
    end
    total
  end
  
  # This method will return the given stat total associated with a given semester id in a given region
  def self.find_stats_semester(semester_id,region_id,stat)
    weeks = find(:all, :conditions => {_(:semester_id) => semester_id})
    total = 0
    # national team stats are not included, so if the region_id is the national_region then it means total all other regions
    if region_id == national_region
      weeks.each do |week| # for each week find the stat and add it to the total
        result = week.weekly_reports.find(:all, :joins => :campus, :conditions => [ "#{__(:region_id, :campus)} != ?", region_id ])
        total += result.sum(&stat) # sum the specific stat
      end
    else # else just find the stats associated with the given region
      weeks.each do |week| # for each week find the stat and add it to the total
        result = week.weekly_reports.find(:all, :joins => :campus, :conditions => [ "#{__(:region_id, :campus)} = ?", region_id ])
        total += result.sum(&stat) # sum the specific stat
      end
    end
    total
  end
  
  # This method will return the given stat total associated with a given semester and a given campus
  def self.find_stats_semester_campus(semester_id,campus_id,stat)
    weeks = find(:all, :conditions => {_(:semester_id) => semester_id})
    total = 0
    weeks.each do |week| # for each week find the stat and add it to the total
      result = week.weekly_reports.find(:all, :conditions => {_(:campus_id) => campus_id})
      total += result.sum(&stat) # sum the specific stat
    end
    total
  end
  
  # This method will return the week id associated with a given end date
  def self.find_week_id(end_date)
    find(:first, :select => _(:id), :conditions => {_(:end_date) => end_date})["#{_(:id)}"]
  end
  
  # This method will return the start date associated with a given week id
  def self.find_start_date(week_id)
    find(:first, :select => :week_endDate, :conditions => {_(:id) => (week_id-1)} )["#{_(:end_date)}"]
  end
  
  # This method will return the end date associated with a given week id
  def self.find_end_date(week_id)
    find(:first, :select => :week_endDate, :conditions => {_(:id) => week_id} )["#{_(:end_date)}"]
  end
  
  # This method will return all the weeks associated with a given month id
  def self.find_weeks_in_month(month_id)
    find(:all, :select => _(:id), :conditions => { _(:month_id) => month_id }, :order => _(:id))   
  end
  
  # This method will return all the weeks associated with a given semester id
  def self.find_weeks_in_semester(semester_id)
    find(:all, :conditions => { _(:semester_id) => semester_id }, :order => _(:id))   
  end
  
  # This method will return an array of all the week end dates in the table
  def self.find_weeks()
    find(:all, :select => _(:end_date), :order => _(:end_date)).collect{ |w| [w.end_date]}   
  end
  
  # This method will return the semester id associated with a given week id
  def self.find_semester_id(id)
    find(:first, :conditions => {_(:id) => id})["#{_(:semester_id)}"]
  end
  
end
