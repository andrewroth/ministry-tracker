class CreateEventGroups < ActiveRecord::Migration
  def self.up
    create_table EventGroup.table_name do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :event_groups
  end
end
