require 'csv'

class GlobalCountry < ActiveRecord::Base
  belongs_to :global_area

  WHQ_MCCS = %w(virtually_led church_led leader_led student_led)
  WHQ_MCCS_TO_PARAMS = {
    "virtually_led" => "virtually-led",
    "church_led" => "church-led",
    "leader_led" => "leader-led",
    "student_led" => "student-led"
  }

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
    GlobalCountry.import_05_country_demographics
    GlobalCountry.import_06_slm_critical_measures
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
        puts "[01_staging] Could not find country by iso code #{iso}"
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
        puts "[02_fiscal] Could not find country by iso code #{iso}"
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
        puts "[03_staff_count] Could not find country by iso code #{iso}"
      else
        c.staff_count_2002 = values[column('C')]
        c.staff_count_2009 = values[column('D')]
        c.save!
      end
    end
  end

  def GlobalCountry.import_04_country_stats_campus
    #WHQ_MCCS = %w(virtually_led church_led leader_led student_led)
    parse('global_dashboard_data/04_a_country_stats_campus.csv', 2) do |values|
      handle_stats_row("student_led", values)
    end
    parse('global_dashboard_data/04_b_country_stats_community.csv', 2) do |values|
      handle_stats_row("leader_led", values)
    end
    parse('global_dashboard_data/04_c_country_stats_coverage.csv', 2) do |values|
      handle_stats_row("church_led", values)
    end
    parse('global_dashboard_data/04_d_country_stats_internet.csv', 2) do |values|
      handle_stats_row("virtually_led", values)
    end
  end

  def GlobalCountry.handle_stats_row(type, values)
    iso = values[column('C')]

    c = GlobalCountry.find_by_iso3 iso
    if c.nil?
      puts "[04_country] Could not find country by iso code #{iso}"
    else
      c.send("#{type}_live_exp=", strip_commas(values[column('E')]).to_i)
      c.send("#{type}_live_dec=", strip_commas(values[column('F')]).to_i)
      c.send("#{type}_new_grth_mbr=", strip_commas(values[column('G')]).to_i)
      c.send("#{type}_mvmt_mbr=", strip_commas(values[column('H')]).to_i)
      c.send("#{type}_mvmt_ldr=", strip_commas(values[column('I')]).to_i)
      c.send("#{type}_new_staff=", strip_commas(values[column('J')]).to_i)
      c.send("#{type}_lifetime_lab=", strip_commas(values[column('K')]).to_i)
      c.save!
    end
  end

  def GlobalCountry.import_05_country_demographics
    parse('global_dashboard_data/05_ccc_country_demographic_data.csv', 2) do |values|
      iso = values[column('D')]

      c = GlobalCountry.find_by_iso3 iso
      if c.nil?
        puts "[05_country] Could not find country by iso code #{iso}"
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
        puts "[06_slm] Could not find country by iso code #{iso}"
      else
        c.total_students = strip_commas(values[column('E')])
        c.total_schools = strip_commas(values[column('F')])
        c.total_spcs = strip_commas(values[column('G')])
        c.names_priority_spcs = values[column('H')]
        c.total_spcs_presence = strip_commas(values[column('I')])
        c.total_spcs_movement = strip_commas(values[column('J')])
        c.total_slm_staff = strip_commas(values[column('K')])
        c.total_new_slm_staff = strip_commas(values[column('L')])
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

  def self.strip_commas(s)
    return s if s.nil?
    s.gsub(",","")
  end
end
