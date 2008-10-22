class CreateColumns < ActiveRecord::Migration
  def self.up
    create_table :columns do |t|
      t.column :title, :string
      t.column :update_clause, :string
      t.column :from_clause, :string
      t.column :select_clause, :string
      t.column :column_type, :string
      t.column :writeable, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :columns
  end
end
