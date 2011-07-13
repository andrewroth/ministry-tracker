class CopyGlobalCountriesToPulse < ActiveRecord::Migration
  
  PREEXISTING_CODES = ["CAN", "AUS", "CHN", "USA", "???"]  # these are already in the Pulse db
  
  def self.up
    GlobalCountry.all.each do |gc|
      unless PREEXISTING_CODES.include?(gc.iso3) || Country.all(:conditions => ["#{Country._(:code)} = ?", gc.iso3]).present?
        Country.new({:desc => gc.name, :code => gc.iso3}).save!
      end
    end
  end

  def self.down
    Country.all.each do |c|
      unless PREEXISTING_CODES.include?(c.code)
        c.destroy
      end
    end
  end
end
