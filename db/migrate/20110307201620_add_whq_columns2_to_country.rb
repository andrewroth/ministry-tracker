class AddWhqColumns2ToCountry < ActiveRecord::Migration
  def self.up
    
    GlobalCountry::WHQ_MCCS.each do |mcc|
      add_column :global_countries, :"#{mcc}_live_exp", :integer
      add_column :global_countries, :"#{mcc}_live_dec", :integer
      add_column :global_countries, :"#{mcc}_new_grth_mbr", :integer
      add_column :global_countries, :"#{mcc}_mvmt_mbr", :integer
      add_column :global_countries, :"#{mcc}_mvmt_ldr", :integer
      add_column :global_countries, :"#{mcc}_new_staff", :integer
      add_column :global_countries, :"#{mcc}_lifetime_lab", :integer
    end
  end

  def self.down
    GlobalCountry::WHQ_MCCS.each do |mcc|
      remove_column :global_countries, :"#{mcc}_live_exp"
      remove_column :global_countries, :"#{mcc}_live_dec"
      remove_column :global_countries, :"#{mcc}_new_grth_mbr"
      remove_column :global_countries, :"#{mcc}_mvmt_mbr"
      remove_column :global_countries, :"#{mcc}_mvmt_ldr"
      remove_column :global_countries, :"#{mcc}_new_staff"
      remove_column :global_countries, :"#{mcc}_lifetime_lab"
    end
  end
end
