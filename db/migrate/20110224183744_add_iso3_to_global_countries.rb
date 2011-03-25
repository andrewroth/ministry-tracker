class AddIso3ToGlobalCountries < ActiveRecord::Migration
  def self.up
    add_column :global_countries, :iso3, :string
  end

  def self.down
    remove_column :global_countries, :iso3
  end
end
