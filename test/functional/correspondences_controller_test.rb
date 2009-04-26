require 'test_helper'

class CorrespondencesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:correspondences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create correspondence" do
    assert_difference('Correspondence.count') do
      post :create, :correspondence => { }
    end

    assert_redirected_to correspondence_path(assigns(:correspondence))
  end

  test "should show correspondence" do
    get :show, :id => correspondences(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => correspondences(:one).to_param
    assert_response :success
  end

  test "should update correspondence" do
    put :update, :id => correspondences(:one).to_param, :correspondence => { }
    assert_redirected_to correspondence_path(assigns(:correspondence))
  end

  test "should destroy correspondence" do
    assert_difference('Correspondence.count', -1) do
      delete :destroy, :id => correspondences(:one).to_param
    end

    assert_redirected_to correspondences_path
  end
end
