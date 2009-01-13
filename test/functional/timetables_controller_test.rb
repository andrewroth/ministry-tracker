require File.dirname(__FILE__) + '/../test_helper'

class TimetablesControllerTest < ActionController::TestCase
  fixtures :timetables, :free_times
  def setup
    login
  end


  test "should show timetable" do
    get :show, :id => timetables(:one).id
    assert_response :success
  end
  
  test "should get edit" do
    get :edit, :id => timetables(:one).id
    assert_response :success
  end
  
  test "should update timetable" do
    put :update, :id => timetables(:one).id, :times => "[[[22200,34200]],[[21600,34200]],[[]],[[]],[[]],[[]],[[]]]", :person_id => "50000"
    assert t = assigns(:timetable)
    assert_equal([], t.errors.full_messages)
    assert_redirected_to person_timetable_path(t.person, t)
  end

end
