class SummerReportReviewer < ActiveRecord::Base
  load_mappings

  belongs_to :person, :class_name => 'Person', :foreign_key => _(:person_id, :summer_report_reviewer)
  belongs_to :summer_report, :class_name => 'SummerReport', :foreign_key => _(:summer_report_id, :summer_report_reviewer)
end
