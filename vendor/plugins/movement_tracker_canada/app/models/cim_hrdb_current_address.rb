class CimHrdbCurrentAddress < CimHrdbAddress
  load_mappings

  doesnt_implement_attributes :address2 => '', :email_validated => false

  validates_format_of   _(:email),
                        :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                        :message    => 'must be valid'
  def address_type() 'current' end
  def extra_prefix() 'curr' end

  def alternate_phone() cell_phone end
  def alternate_phone=(v) cell_phone = v end
end
