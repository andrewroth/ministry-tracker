class SchoolYear < ActiveRecord::Base
  load_mappings
  acts_as_list

  validates_presence_of :name
  
  def description
    @description ||= "#{name}#{level.present? ? ' (' + level + ')' : ''}"
  end
end
