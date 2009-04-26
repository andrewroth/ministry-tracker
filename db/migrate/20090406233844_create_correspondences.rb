class CreateCorrespondences < ActiveRecord::Migration
  def self.up
    create_table :correspondences, :primary_key => :id do |t|
      t.integer :id
      t.integer :correspondence_type_id
      t.integer :person_id
      t.string :receipt
      t.string :state
      t.date :visited
      t.date :completed
      t.date :overdue_at
      t.date :expire_at
      t.text :token_params
      t.timestamps
    end
    add_index :correspondences, :receipt
  end

  def self.down
    remove_index :correspondences, :receipt
    drop_table :correspondences
  end
end
