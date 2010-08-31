class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table Event.table_name do |t|
      t.integer :registrar_event_id
      t.integer :event_group_id
      t.string :register_url

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
