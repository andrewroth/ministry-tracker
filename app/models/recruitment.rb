class Recruitment < ActiveRecord::Base

  QUALIFIED_FOR_RECRUITMENT_LABEL_ID = 2
  INTERESTED_IN_FIELDS = {
    :interested_in_field_staff => 'Field Staff',
    :interested_in_international_field_staff => 'International Field Staff',
    :interested_in_creative_communications => 'Creative Communications',
    :interested_in_francophone_ministry => 'Francophone Ministry',
    :interested_in_expansion_team => 'Expansion Team',
    :interested_in_global_impact_team => 'Global Impact Team',
    :interested_in_student_hq => 'P2C-S HQ (Guelph, Montreal, Langley)',
    :interested_in_hq => 'P2C HQ',
    :interested_in_other => 'P2C Other Ministry (use notes)'
  }
  STATUSES = [['No Challenge Yet', 0], ['Personal Challenge', 1], ['Group Challenge', 2]]

  belongs_to :person
  belongs_to :recruiter, :class_name => 'Person'

  has_many :notes, :as => :noteable

end
