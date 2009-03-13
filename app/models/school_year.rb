class SchoolYear < ActiveRecord::Base
  load_mappings
  acts_as_list
  if $cache
    index _(:id)
    index _(:campus_involvement_id, :id)
  end
  validates_presence_of :name
  
  def description
    @description ||= "#{name}#{level.present? ? ' (' + level + ')' : ''}"
  end
end
