class ChangeCampusInvolvementsIndex < ActiveRecord::Migration
  def self.up
    remove_index :campus_involvements, [:person_id, :campus_id]
    add_index :campus_involvements, [:person_id, :campus_id, :end_date], 
      :name => 'index_campus_involvements_on_p_id_and_c_id_and_end_date',
      :unique => true
  end

  def self.down
    add_index :campus_involvements, [:person_id, :campus_id], :unique => true
    remove_index :campus_involvements, [:person_id, :campus_id, :end_date]
  end
end
