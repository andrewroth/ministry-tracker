class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.string :noteable_type
      t.integer :noteable_id
      t.string :content
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
