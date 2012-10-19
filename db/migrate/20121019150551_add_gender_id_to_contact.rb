class AddGenderIdToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :gender_id, :integer, :default => 0
  end

  def self.down
    remove_column :contacts, :gender_id
  end
end
