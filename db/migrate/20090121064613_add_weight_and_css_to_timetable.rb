class AddWeightAndCssToTimetable < ActiveRecord::Migration
  def self.up
    add_column :free_times, :css_class, :string
    add_column :free_times, :weight, :decimal, :precision => 4, :scale => 2
  end

  def self.down
    remove_column :free_times, :weight
    remove_column :free_times, :css_class
  end
end
