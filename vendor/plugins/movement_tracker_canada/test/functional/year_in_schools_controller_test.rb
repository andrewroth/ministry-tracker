require 'test_helper'

class YearInSchoolsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:year_in_schools)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create year_in_school" do
    assert_difference('YearInSchool.count') do
      post :create, :year_in_school => { }
    end

    assert_redirected_to year_in_school_path(assigns(:year_in_school))
  end

  test "should show year_in_school" do
    get :show, :id => year_in_schools(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => year_in_schools(:one).to_param
    assert_response :success
  end

  test "should update year_in_school" do
    put :update, :id => year_in_schools(:one).to_param, :year_in_school => { }
    assert_redirected_to year_in_school_path(assigns(:year_in_school))
  end

  test "should destroy year_in_school" do
    assert_difference('YearInSchool.count', -1) do
      delete :destroy, :id => year_in_schools(:one).to_param
    end

    assert_redirected_to year_in_schools_path
  end
end
