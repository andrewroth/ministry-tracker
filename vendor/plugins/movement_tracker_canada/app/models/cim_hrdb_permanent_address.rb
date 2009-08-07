class CimHrdbPermanentAddress < CimHrdbAddress
  load_mappings
  belongs_to :country
  
  def country
    Country.find(person_local_country_id) ? Country.find(person_local_country_id).country_shortDesc : ''
  end
  
  def country=(val) 
    self.country_id = Country.find(:first, :conditions => {:country_shortDesc => val}).try(:country_id)
    self.save!
  end

  doesnt_implement_attributes :address2 => '', :email_validated => false

  def address_type() 'permanent' end
  def extra_prefix() 'perm' end
end
