class AddMinistryIdToTrainingCategory < ActiveRecord::Migration
  def self.up
    add_column :training_categories, :ministry_id, :integer
  end

  def self.down
    remove_column :training_categories, :ministry_id
  end
end
