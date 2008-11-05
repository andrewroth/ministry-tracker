class ConvertBusyTimeToFreeTime < ActiveRecord::Migration
  def self.up
    rename_table(:busy_times, :free_times)
  end

  def self.down
    rename_table(:free_times, :busy_times)
  end
end
