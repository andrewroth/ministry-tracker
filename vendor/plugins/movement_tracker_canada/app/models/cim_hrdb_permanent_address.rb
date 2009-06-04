class CimHrdbPermanentAddress < CimHrdbAddress
  load_mappings

  doesnt_implement_attributes :address2 => '', :email_validated => false

  def address_type() 'permanent' end
  def extra_prefix() 'perm' end
end
