class AccountadminAccessgroup < ActiveRecord::Base
  unloadable
  load_mappings
  include Legacy::Accountadmin::AccountadminAccessgroup
end
