class CreateCustomAttributes < ActiveRecord::Migration
  def self.up
    create_table :custom_attributes do |t|
      t.column :ministry_id, :integer
      t.column :name, :string
      t.column :value_type, :string
      t.column :description, :string
    end
    create_table :custom_values do |t|
      t.column :person_id, :integer
      t.column :custom_attribute_id, :integer
      t.column :value, :string
    end
  end

  def self.down
    drop_table :custom_attributes
    drop_table :custom_values
  end
end
