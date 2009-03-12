class CreateTrainingQuestionActivations < ActiveRecord::Migration
  def self.up
    create_table :training_question_activations do |t|
      t.integer :ministry_id, :training_question_id
      t.timestamps
    end
    remove_column :training_questions, :activated
  end

  def self.down
    add_column :training_questions, :activated, :boolean
    drop_table :training_question_activations
  end
end
