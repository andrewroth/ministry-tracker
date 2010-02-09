class Assignmentstatus < ActiveRecord::Base
  load_mappings

  has_many :assignments

  validates_no_association_data :assignments

  # This method will return the status id associated with a given description
  def self.find_status_id(description)
    find(:first, :conditions => {_(:description) => description}).id
  end
end
