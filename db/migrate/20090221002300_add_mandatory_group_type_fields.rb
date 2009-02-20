class AddMandatoryGroupTypeFields < ActiveRecord::Migration
  def self.up
    add_column :group_types, :mentor_priority, :boolean
    add_column :group_types, :public, :boolean
    add_column :group_types, :unsuitability_leader, :integer
    add_column :group_types, :unsuitability_coleader, :integer
    add_column :group_types, :unsuitability_participant, :integer
  end

  def self.down
    remove_column :group_types, :mentor_priority
    remove_column :group_types, :public
    remove_column :group_types, :unsuitability_leader
    remove_column :group_types, :unsuitability_coleader
    remove_column :group_types, :unsuitability_participant
  end
end
