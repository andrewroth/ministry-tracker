class CreateLabelPeople < ActiveRecord::Migration
  def self.up
    create_table :label_people do |t|
      t.integer :label_id
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :label_people
  end
end
