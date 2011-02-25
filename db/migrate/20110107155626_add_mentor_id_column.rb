class AddMentorIdColumn < ActiveRecord::Migration
  def self.up
    begin
      add_column Person.table_name, :person_mentor_id, :integer, :default => 0
    rescue
    end
  end

  def self.down
    begin
      remove_column Person.table_name, :person_mentor_id
    rescue
    end
  end
end
