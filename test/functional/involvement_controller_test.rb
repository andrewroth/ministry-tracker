require File.dirname(__FILE__) + '/../test_helper'

class InvolvementControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    login
  end
  
  test "index" do
    get :index
    assert_response :success
  end
end
