# Year in school is a customisable list belonging to ministry?
class SchoolYear < ActiveRecord::Base
  load_mappings
  acts_as_list
  default_scope :order => _(:position)
  validates_presence_of :name
  
  def description
    @description ||= "#{name}#{level.present? ? ' (' + level + ')' : ''}"
  end
end
