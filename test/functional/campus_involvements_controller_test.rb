require File.dirname(__FILE__) + '/../test_helper'
require 'campus_involvements_controller'

# Re-raise errors caught by the controller.
class CampusInvolvementsController; def rescue_action(e) raise e end; end

class CampusInvolvementsControllerTest < ActionController::TestCase
  fixtures CampusInvolvement.table_name, MinistryInvolvement.table_name, Person.table_name, MinistryRole.table_name

  def setup
    @controller = CampusInvolvementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  test "destroy with permission" do
    login
    xhr :delete, :destroy, :id => 1
    assert_response :success
    assert_not_nil(assigns(:campus_involvement).end_date)
    assert_template 'destroy'
  end
  
  test "destroy WITHOUT permission" do
    login('sue@student.org')
    assert_no_difference "CampusInvolvement.count" do
      xhr :delete, :destroy, :id => 1
    end
    assert_response :success
    assert_template ''
  end

  test "index" do
    login
    xhr :get, :index
    assert_not_nil(assigns(:campus_involvements))
    assert_not_nil(assigns(:involvement_history))
  end

  test "update staff campus involvement" do
    login

    histories_before = Person.find(50000).involvement_history.count
    xhr :get, :update, :id => 1003, :person_id => 50000, :campus_involvement => { :school_year_id => 2 }
    histories_after = Person.find(50000).involvement_history.count
    assert_equal(histories_after, histories_before)
  end

  test "update student campus involvement first involvement" do
    login 'sue@student.org'
    assert_difference "Person.find(2000).involvement_history.count", 1 do
      xhr :post, :update, :id => 1002, :person_id => 2000, :campus_involvement => { :school_year_id => 2, :campus_id => 1 }
    end
    history = Person.find(2000).involvement_history.last
    campus_involvement = CampusInvolvement.find 1002
    assert_equal(history.start_date, campus_involvement.start_date)
    assert_equal(Date.today, history.end_date)
  end

  test "students_restricted_to_creating_under_their_role" do
    login 'sue@student.org'
    xhr :post, :update, :id => 1002, :person_id => 2000, :campus_involvement => { :school_year_id => 2 }, :ministry_involvement => { :ministry_role_id => StaffRole.first.id }
    assert_equal StudentRole, CampusInvolvement.find(1002).find_or_create_ministry_involvement.ministry_role.class
  end

  test "update_student_campus_involvement_second_involvement" do
    login 'sue@student.org'
    assert_difference "Person.find(2000).involvement_history.count", 1 do
      xhr :get, :update, :id => 1004, :person_id => 2000, :campus_involvement => { :school_year_id => 2, :campus_id => 2 }
    end
    history = Person.find(2000).involvement_history.last
    campus_involvement = CampusInvolvement.find 1002
    assert_equal(Date.parse('2009-10-20'), history.start_date)
    assert_equal(Date.today, history.end_date)
  end
end
