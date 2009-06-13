class ChangeAddressStateToInteger < ActiveRecord::Migration
  def self.up
    change_column :addresses, :state, :integer
  end

  def self.down
    change_column :addresses, :state, :string
  end
end
