class AddColumnDataInputNotesToContact < ActiveRecord::Migration
  def self.up
    add_column Contact.table_name, :data_input_notes, :text
  end

  def self.down
    remove_column Contact.table_name, :data_input_notes
  end
end
