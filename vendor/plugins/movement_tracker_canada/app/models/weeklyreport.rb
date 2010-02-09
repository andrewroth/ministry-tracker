class Weeklyreport < ActiveRecord::Base
  
  set_primary_key  _(:id)
  load_mappings
  belongs_to :week, :class_name => 'Week'
  belongs_to :campus, :class_name => 'Campus'
  
  # This method will return all the given stat total during a given month on a given campus
  def self.find_stats_campus(month_id,campus_id,stat)
    result = find(:all, :joins => :week, :conditions => ["#{_(:campus_id)} = ? AND #{_(:month_id, :week)} = ?",campus_id,month_id] )
    total = result.sum(&stat) # sum the specific stat
    total
  end
  
  # This method will return the staff ids that have submitted stats during the given semester
  def self.find_staff(semester_id,campus_id)
    find(:all, :joins => :week, :select => 'DISTINCT staff_id', :conditions => ["#{__(:semester_id, :week)} = ? AND #{_(:campus_id)} = ?", semester_id, campus_id])
  end
  
  # This method is used to check whether a staff has submitted stats for a specific week
  def self.check_submitted(week_id, staff_id)
    find(:first, :conditions => {_(:week_id) => week_id, _(:staff_id) => staff_id})
  end
  
  # This method is used to insert a new weekly stats report
  def self.submit_stats(week_id, campus_id, staff_id, sp_conv, sp_conv_std, gos_pres, gos_pres_std, hs_pres)
    create(_(:week_id) => week_id, _(:campus_id) => campus_id, _(:staff_id) => staff_id, _(:spiritual_conversations) => sp_conv, _(:spiritual_conversations_student) => sp_conv_std, _(:gospel_presentations) => gos_pres, _(:gospel_presentations_student) => gos_pres_std, _(:holyspirit_presentations) => hs_pres )
  end
  
end