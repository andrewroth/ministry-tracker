class Assignmentstatus < ActiveRecord::Base
  load_mappings

  has_many :assignments

  validates_no_association_data :assignments
end
