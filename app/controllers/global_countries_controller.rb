class GlobalCountriesController < ApplicationController
  before_filter :ensure_permission
  skip_before_filter :authorization_filter

  def set_global_country_stage
    @country = GlobalCountry.find params[:id]
    @country.stage = params[:stage].to_i
    @country.save!
  end

  protected

  def ensure_permission
    [283, 5173].include?(@person.id)
  end
end
