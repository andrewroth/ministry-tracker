require 'test_helper'

class AssignmentstatusesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assignmentstatuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assignmentstatus" do
    assert_difference('Assignmentstatus.count') do
      post :create, :assignmentstatus => { }
    end

    assert_redirected_to assignmentstatus_path(assigns(:assignmentstatus))
  end

  test "should show assignmentstatus" do
    get :show, :id => assignmentstatuses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => assignmentstatuses(:one).to_param
    assert_response :success
  end

  test "should update assignmentstatus" do
    put :update, :id => assignmentstatuses(:one).to_param, :assignmentstatus => { }
    assert_redirected_to assignmentstatus_path(assigns(:assignmentstatus))
  end

  test "should destroy assignmentstatus" do
    assert_difference('Assignmentstatus.count', -1) do
      delete :destroy, :id => assignmentstatuses(:one).to_param
    end

    assert_redirected_to assignmentstatuses_path
  end
end
