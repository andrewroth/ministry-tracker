require File.dirname(__FILE__) + '/../test_helper'

class CorrespondencesControllerTest < ActionController::TestCase
  def setup
    CorrespondenceNightly.create_delayed 1, {} # use this so that delayed_job entry is created
    login
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:correspondences)
  end

  test "should show correspondence" do
    get :show, :id => Correspondence.find(:first).id
    assert_response :success
  end

  test "should delete correspondence html" do
    count_before = Correspondence.count
    post :destroy, :id => Correspondence.find(:first).id
    assert_response :redirect
    assert_equal count_before - 1, Correspondence.count
  end

  test "should delete correspondence xml" do
    count_before = Correspondence.count
    post :destroy, :id => Correspondence.find(:first).id, :format => 'xml'
    assert_response :success
    assert_equal count_before - 1, Correspondence.count
  end
end
