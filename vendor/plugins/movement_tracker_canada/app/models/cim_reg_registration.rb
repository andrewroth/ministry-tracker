class CimRegRegistration < ActiveRecord::Base
  load_mappings

  belongs_to :person
  belongs_to :cim_reg_event, :foreign_key => "event_id"
end
