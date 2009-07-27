require_model 'permanent_address'

class PermanentAddress < Address
  before_save :reject
  load_mappings
  belongs_to :person

  doesnt_implement_attributes :address2 => '', :email_validated => false

  def set_address_type
  end
  
  def address_type=()
  end
  
  def address_type() 'permanent' end
  def extra_prefix() 'perm' end
  
  def reject
    throw "Do not save a new Permanent Address in Emu"
  end
  
end
