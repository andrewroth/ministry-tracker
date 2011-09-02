require File.dirname(__FILE__) + '/../test_helper'

class EventCampusesControllerTest < ActionController::TestCase

  def setup
    setup_years
    setup_months
    setup_default_user
    Factory(:event_campus_1)
    login
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_campuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_campus" do
    assert_difference('EventCampus.count') do
      post :create, :event_campus => { }
    end

    assert_redirected_to event_campus_path(assigns(:event_campus))
  end

  test "should show event_campus" do
    get :show, :id => Factory(:event_campus_1).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => Factory(:event_campus_1).to_param
    assert_response :success
  end

  test "should update event_campus" do
    put :update, :id => Factory(:event_campus_1).to_param, :event_campus => { }
    assert_redirected_to event_campus_path(assigns(:event_campus))
  end

  test "should destroy event_campus" do
    assert_difference('EventCampus.count', -1) do
      delete :destroy, :id => Factory(:event_campus_1).to_param
    end

    assert_redirected_to event_campuses_path
  end

end
