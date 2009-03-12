class AddMandateToTrainingQuestionActivation < ActiveRecord::Migration
  def self.up
    add_column :training_question_activations, :mandate, :boolean
    remove_column :training_questions, :mandated
  end

  def self.down
    add_column :training_questions, :mandated, :boolean
    remove_column :training_question_activations, :mandate
  end
end
