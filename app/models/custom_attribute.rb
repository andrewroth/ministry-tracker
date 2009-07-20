class CustomAttribute < ActiveRecord::Base
  load_mappings
  
  belongs_to :ministry
  
  validates_presence_of _(:name), :message => "can't be blank"
  
  def safe_name
    name.downcase.gsub(/[ ?]/, '_')
  end
end
