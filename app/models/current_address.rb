# Addresses are stored seperately to a person
# Question: Why?
class CurrentAddress < Address
  load_mappings
  validates_format_of   _(:email),
                        :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                        :message    => 'must be valid'
  before_create :set_address_type
  
  def set_address_type
    self.address_type = "current"
  end
end
