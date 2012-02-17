require File.dirname(__FILE__) + '/../test_helper'

class InvolvementControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    setup_years
    setup_months
    login
  end
  
  test "index" do
    get :index
    assert_response :success
  end
end
