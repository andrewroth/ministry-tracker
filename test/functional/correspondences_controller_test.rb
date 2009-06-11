require File.dirname(__FILE__) + '/../test_helper'
#require 'correspondence_controller'

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

  test "should action via rcpt correspondence" do
    get :rcpt, :receipt => correspondences(:one).receipt
    assert_response :redirect
  end

  test "will destroy correspondence" do
    assert_difference('Correspondence.count', -1) do
      delete :destroy, :id => correspondences(:one).to_param
    end

    assert_redirected_to correspondences_path
  end
end
