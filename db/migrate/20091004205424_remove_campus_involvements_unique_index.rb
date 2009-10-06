class RemoveCampusInvolvementsUniqueIndex < ActiveRecord::Migration
  def self.up
    remove_index :campus_involvements, [:person_id, :campus_id]
  end

  def self.down
    add_index :campus_involvements, [:person_id, :campus_id], :unique => true
  end
end
