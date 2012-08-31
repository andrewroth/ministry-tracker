class AddTranslationKeyToGroupTypes < ActiveRecord::Migration
  def self.up
    add_column :group_types, :translation_key, :string
    GroupType.reset_column_information
    g = GroupType.find_by_group_type("Discipleship Group (DG)")
    g.translation_key = "discipleship_group"
    g.save!
    g = GroupType.find_by_group_type("Movement Development Area (MDA)")
    g.translation_key = "mda"
    g.save!
    g = GroupType.find_by_group_type("Prayer Group")
    g.translation_key = "prayer_group"
    g.save!
    g = GroupType.find_by_group_type("Servant Team")
    g.translation_key = "servant_team"
    g.save!
    g = GroupType.find_by_group_type("Other")
    g.translation_key = "other"
    g.save!
  end

  def self.down
    remove_column :group_types, :translation_key
  end
end
