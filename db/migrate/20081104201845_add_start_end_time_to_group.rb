class AddStartEndTimeToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :start_time, :integer
    add_column :groups, :end_time, :integer
    add_column :groups, :day, :integer
  end

  def self.down
    remove_column :groups, :day
    remove_column :groups, :end_time
    remove_column :groups, :start_time
  end
end
