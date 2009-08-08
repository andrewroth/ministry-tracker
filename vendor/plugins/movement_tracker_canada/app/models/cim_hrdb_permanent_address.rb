class CimHrdbPermanentAddress < CimHrdbAddress
  load_mappings
  belongs_to :country
  belongs_to :province, :class_name => 'State'
  
  
  def state
    province.province_shortDesc if province
  end

  def state=(v)
    self.province_id = State.find_by_province_id(:first, :conditions => { :province_shortDesc => v}).try(:id)
    self.save!
  end
  
  def country
    Country.find_by_country_id(person_local_country_id) ? Country.find_by_country_id(person_local_country_id).country_shortDesc : ''
  end
  
  def country=(val) 
    self.country_id = Country.find(:first, :conditions => {:country_shortDesc => val}).try(:country_id)
    self.save!
  end

  doesnt_implement_attributes :address2 => '', :email_validated => false

  def address_type() 'permanent' end
  def extra_prefix() 'perm' end
end
