class MinistryCampus < ActiveRecord::Base
  load_mappings
  if $cache
    index _(:id)
    index _(:ministry_id)
  end
  
  belongs_to :ministry
  belongs_to :campus
  
  def <=>(mc)
    self.campus.name <=> mc.campus.name
  end
end
