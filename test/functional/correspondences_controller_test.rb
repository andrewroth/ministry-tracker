require 'test_helper'

class CorrespondencesControllerTest < ActionController::TestCase

  def setup
    login
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:correspondences)
  end

  test "should show correspondence" do
    get :show, :id => correspondences(:one).to_param
    assert_response :success
  end
end
