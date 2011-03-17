class SummerReport < ActiveRecord::Base
  unloadable
  load_mappings

  belongs_to :person, :class_name => 'Person', :foreign_key => _(:person_id, :summer_report)
  belongs_to :year, :class_name => 'Year', :foreign_key => _(:year_id, :summer_report)

  has_many :summer_report_weeks, :foreign_key => _(:summer_report_id, :summer_report_week)
  has_many :summer_report_reviewers, :foreign_key => _(:summer_report_id, :summer_report_reviewer)

  accepts_nested_attributes_for :summer_report_weeks
  accepts_nested_attributes_for :summer_report_reviewers

  validates_associated :person, :year
  validates_uniqueness_of :year_id, :scope => [:person_id], :message => "(you've already submitted a summer report for this year, you can't submit another one)"
  validates_presence_of :person_id
  validates_presence_of :year_id
  validates_presence_of :joined_staff
  validates_presence_of :weeks_of_holiday
  validates_presence_of :monthly_goal
  validates_presence_of :monthly_have
  validates_presence_of :monthly_needed
  validates_presence_of :num_weeks_of_mpd
  validates_presence_of :accountability_partner
end
