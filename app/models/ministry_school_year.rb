class MinistrySchoolYear < ActiveRecord::Base
  belongs_to :ministry
  has_many :terms
  
  #Ensures that this term year not overlap another
  def not_overlapping
    
  end
  
  def name
    this.start.year + "/" + this.end.year
  end
end
