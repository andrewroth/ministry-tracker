class Activity < ActiveRecord::Base
  belongs_to :reporter, :class_name => 'Person', :foreign_key => :reporter_id
  belongs_to :reportable, :polymorphic => true

  validates_presence_of :reporter_id
  validates_presence_of :activity_type_id
  validates_presence_of :reportable_type
  validates_presence_of :reportable_id

  after_create :create_stats

  private

  def create_stats
    case self.activity_type_id
    when 4 # Indicated Decision

      notes = case self.reportable.class.to_s
      when "SurveyContact"
        "Imported from September Launch Follow-up"
      when "DiscoverContact"
        "Imported from Discover Contact Tracking"
      else
        ""
      end

      method_id = case self.reportable.class.to_s
      when "SurveyContact"
        10 # SIQ Follow-up
      when "DiscoverContact"
        4 # Friendship Evangelism
      else
        12 # Other
      end

      prc_attributes = {
          :prc_firstName => self.reportable.first_name,
          :prcMethod_id => method_id,
          :prc_witnessName => self.reporter.full_name,
          :semester_id => Semester.find_semester_from_date(self.created_at).id,
          :campus_id => self.reportable.campus_id,
          :prc_notes => notes,
          :prc_date => self.created_at.to_date
        }

      Prc.new(prc_attributes).save if Prc.find(:all, :conditions => prc_attributes).blank?
    end

  end
end
