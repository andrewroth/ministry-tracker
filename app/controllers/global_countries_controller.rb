class GlobalCountriesController < ApplicationController
  def set_global_country_stage
    @country = GlobalCountry.find params[:id]
    @country.stage = params[:stage].to_i
    @country.save!
  end
end
