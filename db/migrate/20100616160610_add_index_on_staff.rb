class AddIndexOnStaff < ActiveRecord::Migration
  def self.up
    add_index Staff.table_name, [ :person_id ], :unique => true, :name => "unique_person"
  end

  def self.down
    remove_index Staff.table_name, :name => "unique_person"
  end
end
