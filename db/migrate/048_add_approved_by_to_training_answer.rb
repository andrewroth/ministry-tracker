class AddApprovedByToTrainingAnswer < ActiveRecord::Migration
  def self.up
    add_column :training_answers, :approved_by, :string
    remove_column :training_answers, :completed
  end

  def self.down
    add_column :training_answers, :completed, :boolean
    remove_column :training_answers, :string
  end
end
