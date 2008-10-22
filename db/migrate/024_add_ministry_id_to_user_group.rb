class AddMinistryIdToUserGroup < ActiveRecord::Migration
  def self.up
    add_column :user_groups, :ministry_id, :integer
  end

  def self.down
    remove_column :user_groups, :ministry_id
  end
end
