require_model 'country'

class Country < ActiveRecord::Base
  def is_closed() nil end
end
