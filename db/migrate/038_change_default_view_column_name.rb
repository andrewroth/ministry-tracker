class ChangeDefaultViewColumnName < ActiveRecord::Migration
  def self.up
    rename_column :views, :default, :default_view
    add_index :view_columns, :view_id
    add_index :view_columns, [:column_id, :view_id]
  end

  def self.down
    rename_column :views, :default_view, :default
    remove_index :view_columns, :view_id
    remove_index :view_columns, [:column_id, :view_id]
  end
end
