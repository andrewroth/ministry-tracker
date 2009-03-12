class SchoolYear < ActiveRecord::Base
  load_mappings
  acts_as_list
  default_scope :order => :position
  validates_presence_of :name
end
