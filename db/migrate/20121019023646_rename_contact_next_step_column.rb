class RenameContactNextStepColumn < ActiveRecord::Migration
  def self.up
    rename_column :contacts, :next_step, :next_step_id
  end

  def self.down
    rename_column :contacts, :next_step_id, :next_step
  end
end
