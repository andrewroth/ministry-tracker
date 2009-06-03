class Term < ActiveRecord::Base
  belongs_to :ministry_school_year
  has_many :campus_terms
  validates_presence_of :name
  
  def getCurrentTerm
    
  end
  
  #Ensures that this term does not overlap another
  def not_overlapping
    
  end
end
