class GroupType < ActiveRecord::Base
  load_mappings
  index _(:id) if $cache
  belongs_to :ministry
  has_many :groups
  validates_presence_of :group_type, :ministry_id
  
  def unsuitability_metric(id)
    if id == 1
        str = 'Bad'
    elsif id == 2
        str = 'Poor'
    elsif id == 3
        str = 'OK'
    else
        str = 'Unspecified'
    end
  end
end
