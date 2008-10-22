class EmergencyAddress < Address
  load_mappings
  before_create :set_address_type
  
  def set_address_type
    self.address_type = "emergency1"
  end
end
