class UpdateMentorIdColumn < ActiveRecord::Migration
  def self.up
    change_table Person.table_name do |u|
      u.remove :person_mentor_id
      add_column Person.table_name, :person_mentor_id, :integer, :default => nil
    end
    
  end

  def self.down
    change_table Person.table_name do |u|
      u.remove :person_mentor_id
      add_column Person.table_name, :person_mentor_id, :integer, :default => 0
    end
  end
end
