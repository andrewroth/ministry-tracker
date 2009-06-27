# A Training answer is a person-specific response to a training question
class TrainingAnswer < ActiveRecord::Base
  load_mappings
  belongs_to :person, :class_name => "Person", :foreign_key => _(:id, :person)
  belongs_to :training_question, :class_name => "TrainingQuestion", :foreign_key => _(:id, :training_question)
end
