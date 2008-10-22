class CreateCampuses < ActiveRecord::Migration
  def self.up
    create_table :campuses do |t|
      t.column :name, :string
      t.column :address, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zip, :string
      t.column :country, :string
      t.column :phone, :string
      t.column :fax, :string
      t.column :url, :string
      t.column :abbrv, :string
      t.column :is_secure, :boolean
      t.column :enrollment, :integer
      t.column :created_at, :date
      t.column :updated_at, :date
    end
  end

  def self.down
    drop_table :campuses
  end
end
