class AddMissingIndicesToPerson < ActiveRecord::Migration
  def self.up
    add_index(Person.table_name, Person._(:email))
    add_index(Person.table_name, Person._(:mentor_id))
  end

  def self.down
    remove_index(Person.table_name, :column => Person._(:mentor_id))
    remove_index(Person.table_name, :column => Person._(:email))
  end
end
