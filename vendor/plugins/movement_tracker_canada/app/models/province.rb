class Province < ActiveRecord::Base
  load_mappings
  
  # extra stuff so it works with state
  def abbreviation
    self.shortDesc
  end
  
  def abbreviation=(v)
    self.shortDesc = v
  end
  
  def name
    self.desc
  end
  
  def name=(v)
    self.desc = v
  end
  
  def created_at
    throw 'not implemented'
  end
  
  def created_at=(v)
    throw 'not implemented'
  end
  
  def updated_at
    throw 'not implemented'
  end
  
  def updated_at=(v)
    throw 'not implemented'
  end
end
