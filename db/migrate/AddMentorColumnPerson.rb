class AddMentorColumnPerson < ActiveRecord::Migration
  def self.up
    add_column Person.table_name, :person_mentor_id, :integer, :default => 0
  end

  def self.down
    remove_column Person.table_name, :person_mentor_id
  end
end
