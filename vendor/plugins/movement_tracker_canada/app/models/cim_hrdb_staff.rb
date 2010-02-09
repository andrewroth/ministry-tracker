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

  # This method will return the person id associated with a given staff id
  def self.find_person_id(staff_id)
    find(:first, :conditions => {_(:id) => staff_id})["#{_(:person_id)}"]
  end
end
