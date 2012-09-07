class UpdateNoteContentToText < ActiveRecord::Migration
  def self.up
    change_column :notes, :content, :text
  end

  def self.down
  end
end
