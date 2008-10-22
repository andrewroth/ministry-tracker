class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.column :person_id, :integer
      t.column :address_type, :string
      t.column :title, :string
      t.column :address1, :string
      t.column :address2, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zip, :string
      t.column :country, :string
      t.column :phone, :string
      t.column :alternate_phone, :string
      t.column :dorm, :string
      t.column :room, :string
      t.column :email, :string
      t.column :start_date, :date
      t.column :end_date, :date
      t.column :created_at, :date
      t.column :updated_at, :date
    end
    add_index :addresses, :person_id
  end

  def self.down
    remove_index :addresses, :person_id
    drop_table :addresses
  end
end
