class ChangeNamesPrioritySpcsToText < ActiveRecord::Migration
  def self.up
    change_column :global_countries, :names_priority_spcs, :string
  end

  def self.down
    change_column :global_countries, :names_priority_spcs, :integer
  end
end
