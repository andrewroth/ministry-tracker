require 'test_helper'

class SummerReportsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:summer_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create summer_report" do
    assert_difference('SummerReport.count') do
      post :create, :summer_report => { }
    end

    assert_redirected_to summer_report_path(assigns(:summer_report))
  end

  test "should show summer_report" do
    get :show, :id => summer_reports(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => summer_reports(:one).to_param
    assert_response :success
  end

  test "should update summer_report" do
    put :update, :id => summer_reports(:one).to_param, :summer_report => { }
    assert_redirected_to summer_report_path(assigns(:summer_report))
  end

  test "should destroy summer_report" do
    assert_difference('SummerReport.count', -1) do
      delete :destroy, :id => summer_reports(:one).to_param
    end

    assert_redirected_to summer_reports_path
  end
end
