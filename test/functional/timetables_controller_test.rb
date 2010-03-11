require File.dirname(__FILE__) + '/../test_helper'

class TimetablesControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    
    login
  end


  test "should show timetable" do
    get :show, :id => Factory(:timetable_1).id
    assert_response :success
  end
  
  test "should get edit" do
    get :edit, :id => Factory(:timetable_1).id
    assert_response :success
  end
  
  test "should update timetable" do
    put :update, :id => Factory(:timetable_1).id, :times => "[[[22200,34200]],[[21600,34200]],[[]],[[]],[[]],[[]],[[]]]", :person_id => "50000"
    assert t = assigns(:timetable)
    assert_equal([], t.errors.full_messages)
    assert_redirected_to person_timetable_path(t.person, t)
  end
  
  test "should search timetables for best matching time" do
    xhr :post, :search, :leader_ids => [Factory(:person_1).id], :member_ids => [Factory(:person_2).id]
    assert_response :success, @response.body
  end

end
