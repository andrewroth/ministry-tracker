# Question: Is this a marker as to whether  a training question is currently
# active? What is the significance of being active?
class TrainingQuestionActivation < ActiveRecord::Base
  load_mappings
  belongs_to :training_question
  belongs_to :ministry
end
