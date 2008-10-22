class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :name, :string
      t.column :address, :string
      t.column :address_2, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zip, :string
      t.column :country, :string
      t.column :email,  :string
      t.column :url, :string
      t.column :dorm_id, :integer
      t.column :ministry_id, :integer
      t.column :campus_id, :integer
    end
    add_index :groups, :ministry_id
    add_index :groups, :campus_id
    add_index :groups, :dorm_id
  end

  def self.down
    drop_table :groups
  end
end
