class AddRecurToDelayedJobs < ActiveRecord::Migration
  def self.up
    add_column :delayed_jobs, :recur, :boolean, :default => false
    add_column :delayed_jobs, :period, :integer, :limit => 11
    add_column :delayed_jobs, :executions_left, :integer
  end

  def self.down
    remove_column :delayed_jobs, :recur
    remove_column :delayed_jobs, :period
    remove_column :delayed_jobs, :executions_left
  end
end
