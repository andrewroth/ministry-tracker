require File.dirname(__FILE__) + '/../test_helper'
require 'global_dashboard_controller'

# Re-raise errors caught by the controller.
class GlobalDashboardController; def rescue_action(e) raise e end; end

class GlobalDashboardControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    setup_global_areas
    setup_global_countries
    login
    Factory(:global_dashboard_accesses_1)
  end

  def setup_global_areas
    Factory(:global_area_1)
    Factory(:global_area_2)
  end

  def setup_global_countries
    Factory(:global_country_1)
    Factory(:global_country_2)
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_export_all
    get :export, :location => "all"
  end
end
