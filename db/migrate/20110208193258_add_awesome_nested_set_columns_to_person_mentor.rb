class AddAwesomeNestedSetColumnsToPersonMentor < ActiveRecord::Migration
  def self.up
    add_column Person.table_name, :person_mentees_lft, :integer
    add_column Person.table_name, :person_mentees_rgt, :integer
  end

  def self.down
    remove_column Person.table_name, :person_mentees_lft
    remove_column Person.table_name, :person_mentees_rgt
  end
end
