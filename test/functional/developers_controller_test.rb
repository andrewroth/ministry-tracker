require 'test_helper'

class DevelopersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:developers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create developer" do
    assert_difference('Developer.count') do
      post :create, :developer => { }
    end

    assert_redirected_to developer_path(assigns(:developer))
  end

  test "should show developer" do
    get :show, :id => developers(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => developers(:one).id
    assert_response :success
  end

  test "should update developer" do
    put :update, :id => developers(:one).id, :developer => { }
    assert_redirected_to developer_path(assigns(:developer))
  end

  test "should destroy developer" do
    assert_difference('Developer.count', -1) do
      delete :destroy, :id => developers(:one).id
    end

    assert_redirected_to developers_path
  end
end
