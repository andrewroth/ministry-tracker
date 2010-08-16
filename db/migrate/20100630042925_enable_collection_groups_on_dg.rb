class EnableCollectionGroupsOnDg < ActiveRecord::Migration
  def self.up
    gt = GroupType.find_by_group_type "Bible Study"
    gt.has_collection_groups = true
    gt.save!
  end

  def self.down
    gt = GroupType.find_by_group_type "Bible Study"
    gt.has_collection_groups = false
    gt.save!
  end
end
