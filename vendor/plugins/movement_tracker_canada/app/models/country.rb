require_model 'country'

class Country < ActiveRecord::Base
  set_primary_key "country_id"
  has_many :states, :foreign_key => :country_id

  def country() country_desc end
  def is_closed() 
    nil 
  end
end
