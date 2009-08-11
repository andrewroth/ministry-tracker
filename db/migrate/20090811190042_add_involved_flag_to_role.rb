class AddInvolvedFlagToRole < ActiveRecord::Migration
  def self.up
    add_column :ministry_roles, :involved, :boolean
  end

  def self.down
    remove_column :ministry_roles, :involved
  end
end
