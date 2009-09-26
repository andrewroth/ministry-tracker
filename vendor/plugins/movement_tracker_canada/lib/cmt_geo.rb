class CmtGeo
  def self.all_countries
    Country.all.collect{|c| [c.country_desc, c.country_shortDesc]}
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
  def self.campuses_for_state(s, c)
    state = State.find_by_province_shortDesc(s)
    state_id = state.id if state
    return Campus.all.select{|c|  c.province_id == state_id}
  end
  def self.campuses_for_country(c)
    country = Country.find_by_country_shortDesc(c)
    return [] unless country
    country.states.collect{ |p| p.campuses }.flatten.sort{ |c1,c2| c1.name <=> c2.name }
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
