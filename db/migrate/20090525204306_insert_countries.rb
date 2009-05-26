class InsertCountries < ActiveRecord::Migration
  COUNTRIES = [
    ["Canada", "CAN"],
    ["United States", "USA"],
    ["Australia", "AUS"]
  ]

  def self.up
    Country.delete_all()
    for c in COUNTRIES do
      Country.create(:country => c[0], :code => c[1])
    end
  end

  def self.down
    Country.delete_all()
  end
end
