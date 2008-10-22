class CreateViewColumns < ActiveRecord::Migration
  def self.up
    create_table :view_columns do |t|
      t.column :view_id, :string
      t.column :column_id, :string
      t.column :position, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :view_columns
  end
end
