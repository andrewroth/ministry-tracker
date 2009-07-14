class Country < ActiveRecord::Base
  load_mappings
  has_many :states
end
