class AddTranslationKeyToMinistryRole < ActiveRecord::Migration
  def self.up
    add_column :ministry_role, :translation_key, :string
  end

  def self.down
    remove_column :ministry_role, :translation_key
  end
end
