class CimHrdbCurrentAddress < CimHrdbAddress
  load_mappings
  belongs_to :country, :class_name => 'Country', :foreign_key => :local_person_country_id
  
    def country
      Country.find(country_id) ? Country.find(country_id).country_shortDesc : ''
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
