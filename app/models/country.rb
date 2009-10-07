class Country < ActiveRecord::Base
  load_mappings
  named_scope :open, :conditions => {:closed => 0}
end
