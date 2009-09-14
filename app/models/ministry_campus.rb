class MinistryCampus < ActiveRecord::Base
  load_mappings
  
  belongs_to :ministry
  belongs_to :campus
  
  def <=>(mc)
    self.campus.name <=> mc.campus.name
  end
end
