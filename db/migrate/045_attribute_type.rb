class AttributeType < ActiveRecord::Migration
  def self.up
    add_column :custom_attributes, :type, :string
    AttributeType.update_sql("Update #{CustomAttribute.table_name} set #{CustomAttribute._(:type, :custom_attribute)} = 'ProfileQuestion'")
    add_index :custom_attributes, :type
  end

  def self.down
    remove_index :custom_attributes, :type
    remove_column :custom_attributes, :type
  end
end
