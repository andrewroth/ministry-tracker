class AddTreeHeadIdToMinistryCampus < ActiveRecord::Migration
  def self.up
    add_column :ministry_campuses, :tree_head_id, :integer
  end

  def self.down
    remove_column :ministry_campuses, :tree_head_id
  end
end
