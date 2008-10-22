class QuestionActivations < ActiveRecord::Migration
  def self.up
    add_column :training_questions, :activated, :boolean
    add_column :training_questions, :mandated, :boolean
  end

  def self.down
    remove_column :training_questions, :activated
    remove_column :training_questions, :mandated
  end
end
