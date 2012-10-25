class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :activity_type_id
      t.integer :reportable_id
      t.string :reportable_type
      t.integer :reporter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
