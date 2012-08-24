require 'test_helper'

class GlobalCountriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:global_countries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create global_country" do
    assert_difference('GlobalCountry.count') do
      post :create, :global_country => { }
    end

    assert_redirected_to global_country_path(assigns(:global_country))
  end

  test "should show global_country" do
    get :show, :id => global_countries(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => global_countries(:one).to_param
    assert_response :success
  end

  test "should update global_country" do
    put :update, :id => global_countries(:one).to_param, :global_country => { }
    assert_redirected_to global_country_path(assigns(:global_country))
  end

  test "should destroy global_country" do
    assert_difference('GlobalCountry.count', -1) do
      delete :destroy, :id => global_countries(:one).to_param
    end

    assert_redirected_to global_countries_path
  end
end
