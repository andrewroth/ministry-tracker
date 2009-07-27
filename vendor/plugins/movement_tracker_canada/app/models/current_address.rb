require_model 'current_address'

class CurrentAddress < Address
require_model 'current_address'
  before_save :reject
  load_mappings

  doesnt_implement_attributes :address2 => '', :email_validated => false

  validates_format_of   _(:email),
                        :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                        :message    => 'must be valid'
                        
  def address_type() 'current' end
  def extra_prefix() 'curr' end
  def set_address_type
  end
  def address_type=()
  end
  def alternate_phone() cell_phone end
  def alternate_phone=(v) cell_phone = v end  
  
  def reject
    throw "Don't save a new Current Address in Emu."
  end
end
