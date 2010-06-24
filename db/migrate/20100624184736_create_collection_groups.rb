class CreateCollectionGroups < ActiveRecord::Migration
  def self.up
    create_table :campus_ministry_groups do |cg|
      cg.integer "group_id"
      cg.integer "campus_id"
      cg.integer "ministry_id"
    end
    add_column :group_types, :collection_group_name, :string, :default => "{{campus}} interested in a {{group_type}}"
    add_column :group_types, :has_collection_groups, :boolean, :default => false
  end

  def self.down
    drop_table :collection_groups
    remove_column :group_types, :collection_group_name
    remove_column :group_types, :has_collection_groups
  end
end
