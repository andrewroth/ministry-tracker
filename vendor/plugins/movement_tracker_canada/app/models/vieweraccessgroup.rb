class Vieweraccessgroup < ActiveRecord::Base
  
  load_mappings
  
  # This method will return all the access ids associated with a given viewer id
  def self.find_access_ids(viewer_id)
    find(:all, :select => _(:accessgroup_id), :conditions => {_(:viewer_id) => viewer_id})
  end
  
end