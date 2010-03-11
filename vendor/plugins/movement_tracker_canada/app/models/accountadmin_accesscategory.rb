class AccountadminAccesscategory < ActiveRecord::Base
  unloadable
  load_mappings

  include Legacy::Accountadmin::AccountadminAccesscategory
end
