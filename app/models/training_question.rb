# Belongs to a training category and associated with training answers
class TrainingQuestion < ActiveRecord::Base
  load_mappings
  has_many :training_answers, :dependent => :destroy
  has_many :people, :through => :training_answers
  
  has_many :training_question_activations
  has_many :active_ministries, :through => :training_question_activations, :source => :ministry
  
  belongs_to :ministry, :class_name => "Ministry", :foreign_key => _('ministry_id')
  belongs_to :training_category, :class_name => "TrainingCategory", :foreign_key => _("training_category_id")
  
  validates_presence_of :training_category_id, :ministry_id, :activity
  
  def safe_name
    activity.downcase.gsub(' ', '_')
  end
end
