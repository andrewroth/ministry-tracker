class CimHrdbCurrentAddress < CimHrdbAddress
  unloadable
  load_mappings

  include Legacy::Hrdb::CimHrdbCurrentAddress
end
