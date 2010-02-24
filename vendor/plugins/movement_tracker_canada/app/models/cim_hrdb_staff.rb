class CimHrdbStaff < ActiveRecord::Base
  load_mappings
  belongs_to :person

  def boolean_is_active
    case self.is_active
    when 1
      true
    when 0
      false
    end
  end
end
