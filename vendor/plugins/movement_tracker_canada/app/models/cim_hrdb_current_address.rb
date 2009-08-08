class CimHrdbCurrentAddress < CimHrdbAddress
  load_mappings
  belongs_to :country, :class_name => 'Country', :foreign_key => :local_person_country_id
  belongs_to :province, :class_name => 'State', :foreign_key => :local_person_province_id
  
  def state
    if self.person_local_province_id
      State.find_by_province_id(self.person_local_province_id).try(:province_shortDesc)
    end
  end

  def state=(v)
    self.person_local_province_id = State.find(:first, :conditions => { :province_shortDesc => v}).try(:id)
    self.save!
  end
  
  def country
    Country.find_by_country_id(country_id) ? Country.find_by_country_id(country_id).country_shortDesc : ''
  end
  
  def country=(val) 
    self.person_local_country_id = Country.find(:first, :conditions => {:country_shortDesc => val}).try(:country_id)
    self.save!
  end
  
  
  doesnt_implement_attributes :address2 => '', :email_validated => false

  validates_format_of   _(:email),
                        :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                        :message    => 'must be valid'
  def address_type() 'current' end
  def extra_prefix() 'curr' end

  def alternate_phone() cell_phone end
  def alternate_phone=(v) cell_phone = v end
end
