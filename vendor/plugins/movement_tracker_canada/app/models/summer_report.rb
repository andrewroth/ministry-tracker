class SummerReport < ActiveRecord::Base
  unloadable
  load_mappings

  belongs_to :person, :class_name => 'Person', :foreign_key => _(:person_id, :summer_report)
  belongs_to :year, :class_name => 'Year', :foreign_key => _(:year_id, :summer_report)

  has_many :summer_report_weeks, :foreign_key => _(:summer_report_id, :summer_report_week)
  has_many :summer_report_reviewers, :foreign_key => _(:summer_report_id, :summer_report_reviewer)

  accepts_nested_attributes_for :summer_report_weeks
  accepts_nested_attributes_for :summer_report_reviewers, :allow_destroy => true

  before_validation_on_create :initialize_nested_attributes

  validate :has_a_reviewer
  validate :has_a_week
  validates_associated :person, :year
  validates_uniqueness_of :year_id, :scope => [:person_id], :message => "(you've already submitted a summer report for this year, you can't submit another one)"
  validates_presence_of :person_id
  validates_presence_of :year_id
  validates_presence_of :days_of_holiday
  validates_presence_of :monthly_goal
  validates_presence_of :monthly_have
  validates_presence_of :monthly_needed
  validates_presence_of :num_weeks_of_mpd
  validates_presence_of :num_weeks_of_mpm
  
  #-----------------------------------------------------
  # 2012-03-30 Those fields were removed from the form
  #-----------------------------------------------------
  #validates_presence_of :joined_staff
  #validate :accountability_partner_if_doing_mpd
  #-----------------------------------------------------

  STATUS_WAITING = "waiting for review"
  STATUS_APPROVED = "approved!"
  STATUS_DISPROVED = "disapproved (needs amending)"
  STATUS_WAITING_SHORT = "waiting"
  STATUS_APPROVED_SHORT = "approved"
  STATUS_DISPROVED_SHORT = "disapproved"
  STATUS_WAITING_STYLE = "report_waiting"
  STATUS_APPROVED_STYLE = "report_approved"
  STATUS_DISPROVED_STYLE = "report_disapproved"
  WEEKS_OF_MPD = [0,1,2,3,4,5,6,7,8,9,10]
  WEEKS_OF_MPM = [0,1,2,3,4,5,6,7,8,9,10]

  def initialize_nested_attributes
    summer_report_weeks.each { |w| w.summer_report = self }
    summer_report_reviewers.each { |r| r.summer_report = self }
  end

  def has_a_reviewer
    if self.summer_report_reviewers.size < 1 || self.summer_report_reviewers.all?{|r| r.marked_for_destruction? }
      errors.add_to_base("You must choose at least one person, other than yourself, to review your summer schedule")
    end
  end

  def has_a_week
    if self.summer_report_weeks.size < 1 || self.summer_report_weeks.all?{|r| r.marked_for_destruction? }
      errors.add_to_base("Your schedule must have at least one week")
    end
  end

  def accountability_partner_if_doing_mpd
    if self.num_weeks_of_mpd.to_i > 0  &&  self.accountability_partner.blank?
      errors.add_to_base("Since you are doing MPD you must also enter an accountability partner")
    end
  end

  

  def approved?
    approved = false
    disapproved = false

    summer_report_reviewers.each do |r|
      approved    = true if r.reviewed == true && r.approved == true
      disapproved = true if r.reviewed == true && r.approved == false
    end

    (approved && !disapproved)
  end

  def disapproved?
    return true if reviewed? && !approved?
    false
  end

  def reviewed?
    summer_report_reviewers.each {|r| return true if r.reviewed }
    false
  end

  def status
    status = STATUS_WAITING
    status = STATUS_APPROVED if approved?
    status = STATUS_DISPROVED if disapproved?
    status
  end

  def status_short
    status = STATUS_WAITING_SHORT
    status = STATUS_APPROVED_SHORT if approved?
    status = STATUS_DISPROVED_SHORT if disapproved?
    status
  end

  def status_style
    style = STATUS_WAITING_STYLE
    style = STATUS_APPROVED_STYLE if approved?
    style = STATUS_DISPROVED_STYLE if disapproved?
    style
  end

  def send_submission_email(base_url)
    self.summer_report_reviewers.each do |r|
      UserMailer.deliver_summer_report_submitted(r, base_url)
    end
  end

  def send_reviewed_email(base_url)
    UserMailer.deliver_summer_report_reviewed(self, base_url)
  end
end
