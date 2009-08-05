class CmtGeo
  def self.all_countries
    Country.all.collect &:country_shortDesc
  end
  def self.all_states
    Country.all.collect{ |c| 
      [ c.country_shortDesc, c.states.collect{ |s| [ s.name, s.abbrev ] } ]
    }
  end
  def self.states_for_country(c)
    country = find_country(c)
    return [] unless country
    country.states.collect{ |s| [ s.name, s.abbrev ] }
  end
  def self.campuses_for_state(s,c)
    Campus.find :all, :conditions => { :state => s, :country => c }
  end
  def self.lookup_country(c)
    country = find_country(c)
    return nil unless country
    country.name
  end
  
  private

  def self.find_country(c)
    Country.find :first, :conditions => { Country._(:abbrev) => c } 
  end
end
