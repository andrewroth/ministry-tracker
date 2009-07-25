class CmtGeo
  def self.all_countries
    Carmen::COUNTRIES
  end
  def self.all_states
    Carmen::STATES
  end
  def self.states_for_country(c)
    Carmen::states(c)
  end
  def self.campuses_in_state(s,c)
    Campus.find :all, :conditions => { :state => s, :country => c }
  end
  def self.lookup_country(c)
    Carmen::country_name(c)
  end
end
