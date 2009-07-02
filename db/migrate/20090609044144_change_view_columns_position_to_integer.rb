class ChangeViewColumnsPositionToInteger < ActiveRecord::Migration
  def self.up
    change_column :view_columns, :position, :integer
  end

  def self.down
    change_column :view_columns, :position, :string
  end
end
