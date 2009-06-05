class AddResponsiblePerson < ActiveRecord::Migration
  def self.up
    add_column :ministry_involvements, :responsible_person_id, :integer
  end

  def self.down
    remove_column :ministry_involvements, :responsible_person_id
  end
end
