require 'test_helper'

class MinistrySchoolYearsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ministry_school_years)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ministry_school_year" do
    assert_difference('MinistrySchoolYear.count') do
      post :create, :ministry_school_year => { }
    end

    assert_redirected_to ministry_school_year_path(assigns(:ministry_school_year))
  end

  test "should show ministry_school_year" do
    get :show, :id => ministry_school_years(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ministry_school_years(:one).to_param
    assert_response :success
  end

  test "should update ministry_school_year" do
    put :update, :id => ministry_school_years(:one).to_param, :ministry_school_year => { }
    assert_redirected_to ministry_school_year_path(assigns(:ministry_school_year))
  end

  test "should destroy ministry_school_year" do
    assert_difference('MinistrySchoolYear.count', -1) do
      delete :destroy, :id => ministry_school_years(:one).to_param
    end

    assert_redirected_to ministry_school_years_path
  end
end
