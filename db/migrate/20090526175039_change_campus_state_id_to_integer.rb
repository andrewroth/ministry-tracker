class ChangeCampusStateIdToInteger < ActiveRecord::Migration
  def self.up
    change_column :campuses, :state, :integer
  end

  def self.down
    change_column :campuses, :state, :string
  end
end
