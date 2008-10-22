class CreateTrainingCategories < ActiveRecord::Migration
  def self.up
    create_table :training_categories do |t|
      t.string :name
      t.integer :position
      
      t.timestamps
    end
    add_column :training_questions, :training_category_id, :integer
  end
  

  def self.down
    drop_table :training_categories
    remove_column :training_questions, :training_category_id
  end
end
