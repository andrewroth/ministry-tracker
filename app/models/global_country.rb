class GlobalCountry < ActiveRecord::Base
  def isos
    iso3
  end
end
