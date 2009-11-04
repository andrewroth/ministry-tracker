class AddLastHistoryUpdateDateToInvolvements < ActiveRecord::Migration
  def self.up
    add_column :campus_involvements, :last_history_update_date, :date
    add_column :ministry_involvements, :last_history_update_date, :date
  end

  def self.down
    remove_column :campus_involvements, :last_history_update_date
    remove_column :ministry_involvements, :last_history_update_date
  end
end
