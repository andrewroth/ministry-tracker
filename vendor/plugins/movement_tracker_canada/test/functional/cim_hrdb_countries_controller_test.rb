require 'test_helper'

class CimHrdbCountriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:countries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create country" do
    assert_difference('Country.count') do
      post :create, :country => { }
    end

    assert_redirected_to country_path(assigns(:country))
  end

  test "should show country" do
    get :show, :id => countries(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => countries(:one).to_param
    assert_response :success
  end

  test "should update country" do
    put :update, :id => countries(:one).to_param, :country => { }
    assert_redirected_to country_path(assigns(:country))
  end

  test "should destroy country" do
    assert_difference('Country.count', -1) do
      delete :destroy, :id => countries(:one).to_param
    end

    assert_redirected_to countries_path
  end
end
