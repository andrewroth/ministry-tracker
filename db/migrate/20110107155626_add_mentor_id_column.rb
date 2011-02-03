class AddMentorIdColumn < ActiveRecord::Migration
  def self.up
    add_column Person.table_name, :person_mentor_id, :integer, :default => 0 unless Person.columns_hash.has_key?("person_mentor_id")
  end

  def self.down
    remove_column Person.table_name, :person_mentor_id if Person.columns_hash.has_key?("person_mentor_id")
  end
end
