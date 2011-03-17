class SummerReportWeek < ActiveRecord::Base
  unloadable
  load_mappings

  belongs_to :summer_report, :class_name => 'SummerReport', :foreign_key => _(:summer_report_id, :summer_report_week)
  belongs_to :summer_report_assignment, :class_name => 'SummerReportAssignment', :foreign_key => _(:summer_report_assignment_id, :summer_report_week)
  belongs_to :week, :class_name => 'Week', :foreign_key => _(:week_id, :week)

  validates_associated :week, :summer_report_assignment
  validates_uniqueness_of :week_id, :scope => [:summer_report_id], :message => "(can't create multiple summer_report_weeks for a week for the same summer report)"
  validates_presence_of :summer_report
  validates_presence_of :week_id
  validates_presence_of :summer_report_assignment_id
end
