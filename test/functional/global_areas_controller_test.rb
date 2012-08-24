require 'test_helper'

class GlobalAreasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:global_areas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create global_area" do
    assert_difference('GlobalArea.count') do
      post :create, :global_area => { }
    end

    assert_redirected_to global_area_path(assigns(:global_area))
  end

  test "should show global_area" do
    get :show, :id => global_areas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => global_areas(:one).to_param
    assert_response :success
  end

  test "should update global_area" do
    put :update, :id => global_areas(:one).to_param, :global_area => { }
    assert_redirected_to global_area_path(assigns(:global_area))
  end

  test "should destroy global_area" do
    assert_difference('GlobalArea.count', -1) do
      delete :destroy, :id => global_areas(:one).to_param
    end

    assert_redirected_to global_areas_path
  end
end
