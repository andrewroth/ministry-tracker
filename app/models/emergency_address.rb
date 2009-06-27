# Question: Is this why address is an object seperate to a person, so they
# can own multiple addresses?
class EmergencyAddress < Address
  load_mappings
  before_create :set_address_type
  
  def set_address_type
    self.address_type = "emergency1"
  end
end
