class AddWhqColumnsToCountry < ActiveRecord::Migration
  def self.up
    add_column :global_countries, :live_exp, :integer
    add_column :global_countries, :live_dec, :integer
    add_column :global_countries, :new_grth_mbr, :integer
    add_column :global_countries, :mvmt_mbr, :integer
    add_column :global_countries, :mvmt_ldr, :integer
    add_column :global_countries, :new_staff, :integer
    add_column :global_countries, :lifetime_lab, :integer
  end

  def self.down
  end
end
