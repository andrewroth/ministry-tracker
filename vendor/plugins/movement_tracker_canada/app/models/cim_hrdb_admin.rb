class CimHrdbAdmin < ActiveRecord::Base
  load_mappings
  belongs_to :person
  belongs_to :priv
end
