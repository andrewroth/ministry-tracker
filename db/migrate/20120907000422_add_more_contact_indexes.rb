class AddMoreContactIndexes < ActiveRecord::Migration
  def self.up
    add_index(Contact.table_name, :campus_id)
    add_index(Contact.table_name, :gender_id)
    add_index(Contact.table_name, :person_id)
    add_index(Contact.table_name, :priority)
    add_index(Contact.table_name, :status)
    add_index(Contact.table_name, :result)
    add_index(Contact.table_name, :degree)
    add_index(Contact.table_name, :international)
  end

  def self.down
    remove_index(Contact.table_name, :column => :campus_id)
    remove_index(Contact.table_name, :column => :gender_id)
    remove_index(Contact.table_name, :column => :person_id)
    remove_index(Contact.table_name, :column => :priority)
    remove_index(Contact.table_name, :column => :status)
    remove_index(Contact.table_name, :column => :result)
    remove_index(Contact.table_name, :column => :degree)
    remove_index(Contact.table_name, :column => :international)
  end
end
