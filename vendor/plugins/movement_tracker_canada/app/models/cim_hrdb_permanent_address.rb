class CimHrdbPermanentAddress < CimHrdbAddress
  unloadable
  load_mappings
  belongs_to :country_ref, :class_name => 'Country', :foreign_key => 'country_id'
  belongs_to :state_ref, :class_name => 'State', :foreign_key => 'province_id'
  
  doesnt_implement_attributes :address2 => '', :email_validated => false

  def address_type() 'permanent' end
  def extra_prefix() 'perm' end
end
