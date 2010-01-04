class CimHrdbCurrentAddress < CimHrdbAddress
  load_mappings
  belongs_to :country_ref, :class_name => 'Country', :foreign_key => 'person_local_country_id'
  belongs_to :state_ref, :class_name => 'State', :foreign_key => 'person_local_province_id'
  
  doesnt_implement_attributes :address2 => '', :email_validated => false

  validates_format_of   _(:email),
                        :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                        :message    => 'must be valid'
  def address_type() 'current' end
  def extra_prefix() 'curr' end

end
