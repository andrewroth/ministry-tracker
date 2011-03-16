class SummerReport < ActiveRecord::Base
  load_mappings

  belongs_to :person, :class_name => 'Person', :foreign_key => _(:person_id, :summer_report)
  belongs_to :year, :class_name => 'Year', :foreign_key => _(:year_id, :summer_report)

  has_many :summer_report_weeks, :foreign_key => _(:summer_report_id, :summer_report_week)
  has_many :summer_report_reviewers, :foreign_key => _(:summer_report_id, :summer_report_reviewer)
end
