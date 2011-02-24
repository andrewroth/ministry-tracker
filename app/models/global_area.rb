class GlobalArea < ActiveRecord::Base
  def GlobalArea.import
    f = File.read("global_countries.csv")
    lines = f.split("\n")
    lines.shift # remove header

    lines.each_with_index do |line, line_index|
      values = line.split(",", 10).collect{ |h| h =~ /"(.*)"/; $1.to_s }

      area = values.first
      country = values.last

      puts area, country

      global_area = GlobalArea.find_or_create_by_area area
      global_country = GlobalCountry.find_or_create_by_name_and_global_area_id country, global_area.id

      puts global_area.inspect, global_country.inspect
    end
  end
end
