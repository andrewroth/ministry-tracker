require File.dirname(__FILE__) + '/../test_helper'

class InvolvementControllerTest < ActionController::TestCase
  def setup
    login
  end
  
  test "index" do
    get :index
    assert_response :success
  end
end
