require File.dirname(__FILE__) + '/../test_helper'

class EventGroupsControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    Factory(:event_group_1)
    login
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_group" do
    assert_difference('EventGroup.count') do
      post :create, :event_group => { }
    end

    assert_redirected_to event_group_path(assigns(:event_group))
  end

  test "should show event_group" do
    get :show, :id => Factory(:event_group_1).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => Factory(:event_group_1).to_param
    assert_response :success
  end

  test "should update event_group" do
    put :update, :id => Factory(:event_group_1).to_param, :event_group => { }
    assert_redirected_to event_group_path(assigns(:event_group))
  end

  test "should destroy event_group" do
    assert_difference('EventGroup.count', -1) do
      delete :destroy, :id => Factory(:event_group_1).to_param
    end

    assert_redirected_to event_groups_path
  end

end
