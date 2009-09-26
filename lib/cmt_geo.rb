class CmtGeo
  # TODO: need to make all the country stuff properly hit the Country model
  def self.all_countries
    Carmen::COUNTRIES
  end
  def self.all_states
    Carmen::STATES
  end
  def self.states_for_country(c)
    Carmen::states(c) || []
  end
  def self.campuses_for_state(s,c)
    Campus.find :all, :conditions => { :state => s, :country => c }
  end
  def self.campuses_for_country(c)
    Campus.find :all, :conditions => { :country => c }
  end
  def self.lookup_country_code(name)
    Carmen::country_code(name)
  end
  def self.lookup_country_name(code)
    Carmen::country_name(code)
  end
end
