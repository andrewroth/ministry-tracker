class AddIsoCodeToCountry < ActiveRecord::Migration
  def self.up
    add_column :countries, :iso_code, :string
    add_column :countries, :closed, :boolean
    change_column_default :countries, :closed, 0
    Carmen::COUNTRIES.each do |name, code|
      c = Country.find_by_country(name)
      c.update_attribute(:iso_code, code) if c
    end
  end

  def self.down
    remove_column :countries, :iso_code
  end
end
