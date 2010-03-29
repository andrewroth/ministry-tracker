require File.dirname(__FILE__) + '/../test_helper'
require 'campus_involvements_controller'

# Re-raise errors caught by the controller.
class CampusInvolvementsController; def rescue_action(e) raise e end; end

class CampusInvolvementsControllerTest < ActionController::TestCase

  def setup
    reset_campus_involvements_sequences
    Factory(:campusinvolvement)

    setup_default_user
    Factory(:user_3)
    Factory(:person_3)
    Factory(:campusinvolvement_2)
    Factory(:campusinvolvement_4)
    Factory(:ministryinvolvement_4)
    setup_ministry_roles

    @controller = CampusInvolvementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  test "new" do
    login
    xhr :get, :new

    assert_response :success
    assert_equal(Date.today, assigns["campus_involvement"].start_date)
  end

  test "create" do
    login

    xhr :post, :create, :campus_involvement => { :campus_id => 1 }
    assert_equal(1, assigns["campus_involvement"].campus_id)
    assert_equal(50000, assigns["campus_involvement"].person_id)
    assert_equal(true, assigns["updated"])

    xhr :post, :create, :campus_involvement => { :campus_id => 2 }
    assert_equal(2, assigns["campus_involvement"].campus_id)
    assert_equal(50000, assigns["campus_involvement"].person_id)
    assert_equal(false, assigns["updated"])

    Factory(:campus_3)
    Factory(:campusinvolvement_7)

    xhr :post, :create, :campus_involvement => { :campus_id => 3, :school_year_id => 1 }
    assert_equal(nil, assigns["campus_involvement"].end_date)
    assert_equal(Date.today, assigns["campus_involvement"].last_history_update_date)
    assert_equal(false, assigns["updated"])
  end

  test "edit" do
    login

    xhr :post, :edit, :id => 1003

    assert_not_nil(assigns["campus_involvement"])
    assert_not_nil(assigns["ministry_involvement"])
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

  test "update student campus involvement ministry role being updated" do
    login 'sue@student.org'

    xhr :post, :update, :id => 1002, :person_id => 2000, :campus_involvement => { :school_year_id => 1}, :ministry_involvement => { :ministry_role_id => 7 }
    assert_equal(7, ::CampusInvolvement.all(1002).first.find_or_create_ministry_involvement.ministry_role_id)
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
