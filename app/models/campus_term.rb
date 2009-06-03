class CampusTerm < ActiveRecord::Base
  belongs_to :term
  belongs_to :campus
  
  #Ensures that this term does not overlap another
  def not_overlapping

  end
end
