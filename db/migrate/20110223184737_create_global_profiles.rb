class CreateGlobalProfiles < ActiveRecord::Migration
  def self.up
    create_table :global_profiles do |t|
      t.string :gender
      t.string :marital_status
      t.string :language
      t.string :mission_critical_components
      t.string :funding_source
      t.string :staff_status
      t.string :employment_country
      t.string :ministry_location_country
      t.string :position
      t.string :scope
      t.string :position
      t.string :scope

      t.timestamps
    end
  end

  def self.down
    drop_table :global_profiles
  end
end
