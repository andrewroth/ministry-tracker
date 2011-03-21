require 'csv'

class GlobalCountry < ActiveRecord::Base
  belongs_to :global_area

  def isos
    iso3
  end

  def GlobalCountry.reset_data
    GlobalCountry.delete_all
    GlobalProfile.delete_all
    GlobalArea.delete_all

    GlobalCountry.import_00_metadata
    GlobalCountry.import_01_staging
    GlobalCountry.import_02_fiscal
    GlobalCountry.import_03_a_staff_demographics
    GlobalCountry.import_03_b_staff_count
    GlobalCountry.import_04_country_stats_campus
  end

  def GlobalCountry.import_00_metadata
    parse('global_dashboard_data/00_metadata.csv', 1) do |values|
      country_name = values[column('D')]
      country_iso3 = values[column('E')]
      area_name = values[column('A')]

      global_area = GlobalArea.find_or_create_by_area area_name 

      c = GlobalCountry.find_or_create_by_iso3 country_iso3
      c.name = country_name
      c.global_area = global_area
      c.save!
    end
  end

  def GlobalCountry.import_01_staging
    parse('global_dashboard_data/01_staging.csv', 1) do |values|
      iso = values[column('C')]
      stage = values[column('D')].to_i
      c = GlobalCountry.find_by_iso3 iso
      if c.nil?
        puts "Could not find country by iso code #{iso}"
      else
        c.stage = stage
        c.save!
      end
    end
  end

  def GlobalCountry.import_02_fiscal
    parse('global_dashboard_data/02_fiscal.csv', 1) do |values|
      iso = values[column('D')]
      perc = values[column('E')]
      if perc == "Missing" then perc = nil
      else perc =~ /(\d+)%/
        perc = $1
      end
      inc = values[column('F')].gsub(',','').to_i

      c = GlobalCountry.find_by_iso3 iso
      if c.nil?
        puts "Could not find country by iso code #{iso}"
      else
        c.locally_funded_FY10 = perc
        c.total_income_FY10 = inc
        c.save!
      end
    end
  end

  def GlobalCountry.import_03_a_staff_demographics
    parse('global_dashboard_data/03_a_staff_demographics.csv', 1) do |values|
      gc = GlobalProfile.new
      gc.gender = values[column('A')]
      gc.marital_status = values[column('B')]
      gc.language = values[column('C')]
      gc.mission_critical_components = values[column('D')]
      gc.funding_source = values[column('E')]
      gc.staff_status = values[column('F')]
      gc.employment_country = values[column('G')]
      gc.ministry_location_country = values[column('H')]
      gc.position = values[column('I')]
      gc.scope = values[column('J')]
      gc.save!
    end
  end

  def GlobalCountry.import_03_b_staff_count
    parse('global_dashboard_data/03_b_staff_count.csv', 1) do |values|
      iso = values[column('B')]

      c = GlobalCountry.find_by_iso3 iso
      if c.nil?
        puts "Could not find country by iso code #{iso}"
      else
        c.staff_count_2002 = values[column('C')]
        c.staff_count_2009 = values[column('D')]
        c.save!
      end
    end
  end

  def GlobalCountry.import_04_country_stats_campus
    parse('global_dashboard_data/04_a_country_stats_campus.csv', 2) do |values|
      handle_stats_row(values)
    end
    parse('global_dashboard_data/04_b_country_stats_community.csv', 2) do |values|
      handle_stats_row(values)
    end
    parse('global_dashboard_data/04_c_country_stats_coverage.csv', 2) do |values|
      handle_stats_row(values)
    end
    parse('global_dashboard_data/04_d_country_stats_internet.csv', 2) do |values|
      handle_stats_row(values)
    end
  end

  def GlobalCountry.handle_stats_row(values)
    iso = values[column('C')]

    c = GlobalCountry.find_by_iso3 iso
    if c.nil?
      puts "Could not find country by iso code #{iso}"
    else
      c.live_exp = values[column('A')]
      c.live_dec = values[column('B')]
      c.new_grth_mbr = values[column('C')]
      c.mvmt_mbr = values[column('D')]
      c.mvmt_ldr = values[column('E')]
      c.new_staff = values[column('F')]
      c.lifetime_lab = values[column('G')]
      c.save!
    end
  end

  def GlobalCountry.import_05_country_demographics
    parse('global_dashboard_data/05_ccc_country_demographic_data.csv', 1) do |values|
      iso = values[column('D')]

      c = GlobalCountry.find_by_iso3 iso
      if c.nil?
        puts "Could not find country by iso code #{iso}"
      else
        c.pop_2010 = values[column('E')]
        c.pop_2015 = values[column('F')]
        c.pop_2020 = values[column('G')]
        c.pop_wfb_gdppp = values[column('H')]
        c.perc_christian = values[column('I')]
        c.perc_evangelical = values[column('J')]
        c.save!
      end
    end
  end

  def GlobalCountry.import_06_slm_critical_measures
    parse('global_dashboard_data/06_slm_critical_measures.csv', 3) do |values|
      iso = values[column('D')]

      c = GlobalCountry.find_by_iso3 iso
      if c.nil?
        puts "Could not find country by iso code #{iso}"
      else
        c.total_students = values[column('E')]
        c.total_schools = values[column('F')]
        c.total_spcs = values[column('G')]
        c.names_priority_spcs = values[column('H')]
        c.total_spcs_presence = values[column('I')]
        c.total_spcs_movement = values[column('J')]
        c.total_slm_staff = values[column('K')]
        c.total_new_slm_staff = values[column('L')]
        c.save!
      end
    end
  end

  private

  def self.column(c)
    c[0] - 'A'[0]
  end

  def self.parse(filename, skip = 0)
    CSV::Reader.parse(File.open(filename)) do |values|
      if skip > 0
        skip -=  1
        next
      end

      # remove [#] comment strings
      values = values.collect{ |v| v.to_s.gsub(/\[\d+\]/, '') }
      yield values
    end
  end
end
