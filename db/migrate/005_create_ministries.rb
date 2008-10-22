class CreateMinistries < ActiveRecord::Migration
  def self.up
    create_table :ministries do |t|
      t.column :parent_id, :integer
      t.column :name, :string
      t.column :address, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zip, :string
      t.column :country, :string
      t.column :phone, :string
      t.column :fax, :string
      t.column :email, :string
      t.column :url, :string
      t.column :created_at, :date
      t.column :updated_at, :date
    end
    add_index :ministries, :parent_id
  end

  def self.down
    remove_index :ministries, :parent_id
    drop_table :ministries
  end
end
