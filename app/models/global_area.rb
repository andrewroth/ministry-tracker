class GlobalArea < ActiveRecord::Base
  has_many :global_countries, :order => "name"

  def GlobalArea.import
    f = File.read("global_countries.csv")
    lines = f.split("\n")
    lines.shift # remove header

    lines.each_with_index do |line, line_index|
      values = line.split(",", 10).collect{ |h| h =~ /"(.*)"/; $1.to_s }

      area = values.first
      country = values.third
      iso3 = values.last

      puts area, country

      global_area = GlobalArea.find_or_create_by_area area
      global_country = GlobalCountry.find_or_create_by_name_and_global_area_id country, global_area.id
      global_country.iso3 = iso3
      global_country.save!

      puts global_area.inspect, global_country.inspect
    end
  end

  def isos
    global_countries.collect(&:isos).flatten
  end
end
