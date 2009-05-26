class AddDelayedJobIdToMovementTracker < ActiveRecord::Migration
  def self.up
    add_column :correspondences, :delayed_job_id, :integer
  end

  def self.down
    remove_column :correspondences, :delayed_job_id
  end
end
