class CreateMerges < ActiveRecord::Migration
  def self.up
    create_table :merges do |t|
      t.integer :person_id
      t.integer :keep_person_id
      t.integer :keep_viewer_id
      t.integer :other_person_id
      t.integer :other_viewer_id
      t.boolean :success
      t.text :error_message

      t.timestamps
    end
  end

  def self.down
    drop_table :merges
  end
end
