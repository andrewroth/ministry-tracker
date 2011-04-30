class AddDemogToGlobalCountry < ActiveRecord::Migration
  def self.up
    add_column :global_countries, :pop_2010, :integer
    add_column :global_countries, :pop_2015, :integer
    add_column :global_countries, :pop_2020, :integer
    add_column :global_countries, :pop_wfb_gdppp, :integer
    add_column :global_countries, :perc_christian, :float
    add_column :global_countries, :perc_evangelical, :float
  end

  def self.down
    remove_column :global_countries, :pop_2010
    remove_column :global_countries, :pop_2015
    remove_column :global_countries, :pop_2020
    remove_column :global_countries, :pop_wfb_gdppp
    remove_column :global_countries, :perc_christian
    remove_column :global_countries, :perc_evangelical
  end
end
