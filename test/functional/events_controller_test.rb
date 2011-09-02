require File.dirname(__FILE__) + '/../test_helper'

class EventsControllerTest < ActionController::TestCase

  def setup
    setup_years
    setup_months
    Factory(:event_group_1)
    Factory(:event_campus_1)
    Factory(:event_1)
    setup_default_user
    login
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, :event => { :event_group_id => 1, :registrar_event_id => 1234567890 }
    end
  end

  test "should show event" do
    get :show, :id => Event.first.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => Event.first.id
    assert_response :success
  end

  test "should update event" do
    put :update, :id => Event.first.id, :event => { :event_group_id => 2 }
    assert_equal 2, Event.first.event_group_id
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, :id => Event.first.id
    end
  end

end
