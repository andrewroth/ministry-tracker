require 'csv'

class GlobalCountry < ActiveRecord::Base
  belongs_to :global_area

  def isos
    iso3
  end

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

  def GlobalCountry.import_demog
    h1 = false
    h2 = false
    CSV::Reader.parse(File.open('CCCCountryDemogDataQuery.csv')) do |values|
      if !h1
        h1 = true
      elsif !h2
        h2 = true
      else
        puts values.inspect
        name = values.shift
        iso = values.shift
        fips = values.shift
        pop_2010 = values.shift
        pop_2015 = values.shift
        pop_2020 = values.shift
        pop_wfb_gdppp = values.shift
        perc_christian = values.shift
        perc_evangelical = values.shift

        country = GlobalCountry.find_or_create_by_name name
        country.pop_2010 = pop_2010.to_i
        country.pop_2015 = pop_2015.to_i
        country.pop_2020 = pop_2020.to_i
        country.pop_wfb_gdppp = pop_wfb_gdppp.to_i
        country.perc_christian = perc_christian.to_f
        country.perc_evangelical = perc_evangelical.to_f
        country.save!
      end
    end
  end

  def GlobalCountry.import_fiscal
    CSV::Reader.parse(File.open('Fiscal_Year_2010.csv')) do |values|
      next if values.include?("Ministry office")
      if values.second.present?
        name = values.second
        values.third =~ /(.*)%/
        locally_funded_FY10 = $1
        total_income_FY10 = values.fourth.gsub(',','').to_i
        #puts "values: #{values.inspect} #{locally_funded_FY10} #{total_income_FY10}"
        c = GlobalCountry.find_or_create_by_name name
        c.locally_funded_FY10 = locally_funded_FY10
        c.total_income_FY10 = total_income_FY10
        #puts locally_funded_FY10, total_income_FY10
        c.save!
      end
    end
  end

  def GlobalCountry.import_staff_count
    head = false
    CSV::Reader.parse(File.open('staff_count_2010.csv')) do |values|
      if head
        head = true
      else
        name = values.first
        staff_count_2002 = values.second
        staff_count_2009 = values.third
        puts name
        c = GlobalCountry.find_or_create_by_name name
        c.staff_count_2002 = staff_count_2002
        c.staff_count_2009 = staff_count_2009
        c.save!
      end
    end
  end
end
