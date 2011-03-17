class AddStaffCountsToGlobalCountry < ActiveRecord::Migration
  def self.up
    add_column :global_countries, :staff_count_2002, :integer
    add_column :global_countries, :staff_count_2009, :integer
  end

  def self.down
    remove_column :global_countries, :staff_count_2002
    remove_column :global_countries, :staff_count_2009
  end
end
