class CimHrdbPriv < ActiveRecord::Base
  load_mappings
  belongs_to :person
  belongs_to :priv
  has_many :accountadmin_accountadminaccesses
end
