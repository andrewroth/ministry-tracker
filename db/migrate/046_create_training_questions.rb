class CreateTrainingQuestions < ActiveRecord::Migration
  def self.up
    create_table :training_questions do |t|
      t.string :activity
      t.integer :ministry_id
      t.timestamps
    end
    create_table :training_answers do |t|
      t.integer :training_question_id, :person_id
      t.date :completed_at
      t.boolean :completed
      
      t.timestamps
    end
  end

  def self.down
    drop_table :training_questions
    drop_table :training_answers
  end
end
