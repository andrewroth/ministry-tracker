class CimHrdbStaff < ActiveRecord::Base
  load_mappings
  belongs_to :person
end
