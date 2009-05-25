class AddExecutionsLeftToDelayedJobs < ActiveRecord::Migration
  def self.up
    add_column :delayed_jobs, :executions_left, :integer
  end

  def self.down
    remove_column :delayed_jobs, :executions_left
  end
end
