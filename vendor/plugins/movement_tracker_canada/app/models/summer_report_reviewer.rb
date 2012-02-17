class SummerReportReviewer < ActiveRecord::Base
  unloadable
  load_mappings

  belongs_to :person, :class_name => 'Person', :foreign_key => _(:person_id, :summer_report_reviewer)
  belongs_to :summer_report, :class_name => 'SummerReport', :foreign_key => _(:summer_report_id, :summer_report_reviewer)

  validates_associated :person
  validates_uniqueness_of :person_id, :scope => [:summer_report_id], :message => "(can't add the same person as a reviewer twice to the same summer report)"
  validates_presence_of :summer_report
  validates_presence_of :person_id
end
