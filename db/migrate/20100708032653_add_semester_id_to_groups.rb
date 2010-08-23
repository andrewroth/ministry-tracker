class AddSemesterIdToGroups < ActiveRecord::Migration
  def self.up
    add_column Group.table_name, :semester_id, :integer
    add_index Group.table_name, :semester_id
  end

  def self.down
    remove_index Group.table_name, :semester_id
    remove_column Group.table_name, :semester_id
  end
end
