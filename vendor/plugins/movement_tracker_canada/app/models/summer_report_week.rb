class SummerReportWeek < ActiveRecord::Base
  load_mappings

  belongs_to :summer_report, :class_name => 'SummerReport', :foreign_key => _(:summer_report_id, :summer_report_week)
  belongs_to :summer_report_assignment, :class_name => 'SummerReportAssignment', :foreign_key => _(:summer_report_assignment_id, :summer_report_week)
  belongs_to :week, :class_name => 'Week', :foreign_key => _(:week_id, :week)
end
