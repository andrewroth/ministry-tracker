class InsertCountries < ActiveRecord::Migration
  COUNTRIES = [
    ["Canada", "CAN"],
    ["United States", "USA"],
    ["Australia", "AUS"]
  ]

  def self.up
    if Country.count > 0
      puts "Skipping initial country creation, since you already have some."
      return
    end

    for c in COUNTRIES do
      Country.create(:country => c[0], :code => c[1])
    end
  end

  def self.down
    Country.delete_all()
  end
end
