class AddTranslationKeyToMinistryRole < ActiveRecord::Migration
  def self.up
    add_column :ministry_roles, :translation_key, :string
    MinistryRole.reset_column_information
    MinistryRole.all.each do |r|
      r.translation_key = r.name.downcase.gsub(' ', '_')
      r.save!
    end
  end

  def self.down
    remove_column :ministry_roles, :translation_key
  end
end
