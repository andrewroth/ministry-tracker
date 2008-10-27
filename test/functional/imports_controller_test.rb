require File.dirname(__FILE__) + '/../test_helper'

class ImportsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def setup
    login
  end
  
  test "new" do
    get :new
    assert assigns(:import)
    assert_response :success
  end
end
