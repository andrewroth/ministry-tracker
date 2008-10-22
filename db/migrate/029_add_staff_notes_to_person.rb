class AddStaffNotesToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :staff_notes, :string
  end

  def self.down
    remove_column :people, :staff_notes
  end
end
