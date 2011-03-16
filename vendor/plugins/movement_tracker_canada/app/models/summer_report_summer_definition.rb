class SummerReportSummerDefinition < ActiveRecord::Base
  load_mappings

  belongs_to :year, :class_name => 'Year', :foreign_key => _(:year_id, :summer_report_summer_definition)
  belongs_to :first_week, :class_name => 'Week', :foreign_key => _(:first_week_id, :summer_report_summer_definition)
  belongs_to :last_week, :class_name => 'Week', :foreign_key => _(:last_week_id, :summer_report_summer_definition)
end
