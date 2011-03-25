class AddGlobalCountryCriticalMeasures < ActiveRecord::Migration
  def self.up
    add_column :global_countries, :total_students, :integer
    add_column :global_countries, :total_schools, :integer
    add_column :global_countries, :total_spcs, :integer
    add_column :global_countries, :names_priority_spcs, :integer
    add_column :global_countries, :total_spcs_presence, :integer
    add_column :global_countries, :total_spcs_movement, :integer
    add_column :global_countries, :total_slm_staff, :integer
    add_column :global_countries, :total_new_slm_staff, :integer
  end

  def self.down
    remove_column :global_countries, :total_students
    remove_column :global_countries, :total_schools
    remove_column :global_countries, :total_spcs
    remove_column :global_countries, :names_priority_spcs
    remove_column :global_countries, :total_spcs_presence
    remove_column :global_countries, :total_spcs_movement
    remove_column :global_countries, :total_slm_staff
    remove_column :global_countries, :total_new_slm_staff
  end
end
