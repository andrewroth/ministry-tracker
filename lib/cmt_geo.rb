class CmtGeo
  # TODO: need to make all the country stuff properly hit the Country model
  def self.all_countries
    @@all_countries ||= Country.open(:order => :country).collect {|c| [c.country, c.iso_code]}
  end
  def self.all_states
    Carmen::STATES
  end
  def self.states_for_country(c)
    Carmen::states(c) || []
  end
  def self.campuses_for_state(s,c)
    Campus.find :all, :conditions => { :state => s, :country => Country.find_by_iso_code(c).try(:code) }, :order => :name
  end
  def self.campuses_for_country(c)
    Campus.find :all, :conditions => { :country => c }
  end
  def self.lookup_country_code(name)
    Country.find_by_country(name).try(:iso_code)
  end
  def self.lookup_country_name(code)
    Country.find_by_iso_code(code).try(:country)
  end
end
