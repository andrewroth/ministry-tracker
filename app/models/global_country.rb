require 'csv'

class GlobalCountry < ActiveRecord::Base
  belongs_to :global_area

  def isos
    iso3
  end

  # NOTE: there were 254 countries.  GlobalCountry.count 319.
  def GlobalCountry.import_stages
    area_mappings = {
      "E. Asia Opportunties" => "East Asia Opportunities",
      "E. Asia Orient" => "East Asia Orient",
      "Eastern Europe & Russia" => "Eastern Europe",
      "N. America, Oceania" => "CanOceUS",
      "Southern & Eastern Africa" => "Southern/Eastern Africa"
    }

    f = File.read("stages.csv")
    lines = f.split("\n")
    lines.shift # remove header

    header = true
    CSV::Reader.parse(File.open('stages.csv')) do |values|
      if header
        header = false
        next
      end

      area = values.first
      country = values.second
      stage = values.third

      area = area_mappings[area] || area

      puts area, country, stage

      global_area = GlobalArea.find_or_create_by_area area
      global_country = GlobalCountry.find_or_create_by_name_and_global_area_id country, global_area.id
      global_country.stage = stage
      global_country.save!

      #puts global_area.inspect, global_country.inspect
    end
  end

  # NOTE: there were 254 countries.  GlobalCountry.count 319.
  def GlobalCountry.import_whq
    area_mappings = {
      "ASEO" => "South East Asia",
      "E.Eu." => "Eastern Europe",
      "EA Opps" => "East Asia Opportunities",
      "EA Orient" => "East Asia Orient",
      "Francophon" => "Francophone Africa",
      "NAMEstan" => "NAMESTAN",
      "Oceania" => "CanOceUS",
      "SE Africa" => "Southern/Eastern Africa",
      "SouthAmer" => "Latin America",
      "SouthAsia" => "South East Asia",
      "USA" => "CanOceUS"
    }

    f = File.read("stages.csv")
    lines = f.split("\n")
    lines.shift # remove header

    header = true
    headers = nil
    CSV::Reader.parse(File.open('whq.csv')) do |values|
      if header
        headers = values
        headers.shift # remove country
        headers.shift # remove area
        header = false
        next
      end

      country = values.shift
      area = values.shift
      area = area_mappings[area] || area

      global_area = GlobalArea.find_or_create_by_area area
      global_country = GlobalCountry.find_or_create_by_name_and_global_area_id country, global_area.id

      headers.each do |att|
        value = values.shift
        global_country.send("#{att.gsub(' ','').underscore}=", value)
      end
      global_country.save!
    end
  end

end
