require 'test_helper'

class CorrespondenceTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:correspondence_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create correspondence_type" do
    assert_difference('CorrespondenceType.count') do
      post :create, :correspondence_type => { }
    end

    assert_redirected_to correspondence_type_path(assigns(:correspondence_type))
  end

  test "should show correspondence_type" do
    get :show, :id => correspondence_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => correspondence_types(:one).to_param
    assert_response :success
  end

  test "should update correspondence_type" do
    put :update, :id => correspondence_types(:one).to_param, :correspondence_type => { }
    assert_redirected_to correspondence_type_path(assigns(:correspondence_type))
  end

  test "should destroy correspondence_type" do
    assert_difference('CorrespondenceType.count', -1) do
      delete :destroy, :id => correspondence_types(:one).to_param
    end

    assert_redirected_to correspondence_types_path
  end
end
