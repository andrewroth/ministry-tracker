class AddIndexOnStaff < ActiveRecord::Migration
  def self.up
    add_index Staff.table_name, [ :staff_id, :person_id ], :unique => true, :name => "unique_staff_person"
  end

  def self.down
    remove_index Staff.table_name, :name => "unique_staff_person"
  end
end
