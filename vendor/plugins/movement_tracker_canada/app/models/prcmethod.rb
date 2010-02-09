class Prcmethod < ActiveRecord::Base
  
  load_mappings
  has_many :prc, :class_name => 'Prc', :primary_key => _(:id), :foreign_key => _(:id)
  
  # This method will return an array of all the prc method descriptions
  def self.find_methods()
    find(:all, :select => _(:description)).collect{ |m| [m.description] }
  end
  
  # This method will return the method id associated with a given description
  def self.find_method_id(description)
    find(:first, :conditions => {_(:description) => description})["#{_(:id)}"]
  end
  
  # This method will return the method description associated witha  given id
  def self.find_method_description(id)
    find(:first, :conditions => {_(:id) => id})["#{_(:description)}"]
  end
  
end
