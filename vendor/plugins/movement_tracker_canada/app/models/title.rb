class Title < ActiveRecord::Base
  unloadable
  load_mappings

  has_many :people

  validates_no_association_data :people
end
