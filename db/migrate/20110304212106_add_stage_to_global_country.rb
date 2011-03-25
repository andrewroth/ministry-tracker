class AddStageToGlobalCountry < ActiveRecord::Migration
  def self.up
    add_column :global_countries, :stage, :integer
  end

  def self.down
    remove_column :global_countries, :stage
  end
end
