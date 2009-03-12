class TrainingQuestionActivation < ActiveRecord::Base
  load_mappings
  belongs_to :training_question
  belongs_to :ministry
end
