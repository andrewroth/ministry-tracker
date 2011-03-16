class SummerReportAssignment < ActiveRecord::Base
  load_mappings

  has_many :summer_report_weeks, :foreign_key => _(:summer_report_assignment_id, :summer_report_week)
end
