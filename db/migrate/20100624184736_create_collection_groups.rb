class CreateCollectionGroups < ActiveRecord::Migration
  def self.up
    create_table CampusMinistryGroup.table_name do |cg|
      cg.integer "group_id"
      cg.integer "campus_id"
      cg.integer "ministry_id"
    end
    add_column GroupType.table_name, :collection_group_name, :string, :default => "{{campus}} interested in a {{group_type}}"
    add_column GroupType.table_name, :has_collection_groups, :boolean, :default => false
  end

  def self.down
    drop_table CampusMinistryGroup.table_name
    remove_column GroupType.table_name, :collection_group_name
    remove_column GroupType.table_name, :has_collection_groups
  end
end
