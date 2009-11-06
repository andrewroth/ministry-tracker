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

  def test_destroy_with_permission
    login
    xhr :delete, :destroy, :id => 1
    assert_response :success
    assert_not_nil(assigns(:campus_involvement).end_date)
    assert_template 'destroy'
  end
  
  def test_destroy_WITHOUT_permission
    login('sue@student.org')
    assert_no_difference "CampusInvolvement.count" do
      xhr :delete, :destroy, :id => 1
    end
    assert_response :success
    assert_template ''
  end

  def test_index
    login
    xhr :get, :index
    assert_not_nil(assigns(:campus_involvements))
    assert_not_nil(assigns(:involvement_history))
    puts assigns(:campus_involvements).inspect
    puts assigns(:involvement_history).inspect
  end

  def test_update_staff_campus_involvement
    login

    histories_before = Person.find(50000).involvement_history.count
    xhr :get, :update, :id => 1003, :person_id => 50000, :campus_involvement => { :school_year_id => 2 }
    histories_after = Person.find(50000).involvement_history.count
    assert_equal(histories_after, histories_before)
  end

  def test_update_student_campus_involvement_first_involvement
    login 'sue@student.org'
    histories_before = Person.find(2000).involvement_history.count
    xhr :get, :update, :id => 1002, :person_id => 2000, :campus_involvement => { :school_year_id => 2 }
    histories_after = Person.find(2000).involvement_history.count
    assert_equal(histories_before + 1, histories_after)
    history = Person.find(2000).involvement_history.last
    campus_involvement = CampusInvolvement.find 1002
    assert_equal(history.start_date, campus_involvement.start_date)
    assert_equal(Date.today, history.end_date)
  end

  def test_update_student_campus_involvement_second_involvement
    login 'sue@student.org'
    histories_before = Person.find(2000).involvement_history.count
    xhr :get, :update, :id => 1004, :person_id => 2000, :campus_involvement => { :school_year_id => 2 }
    histories_after = Person.find(2000).involvement_history.count
    assert_equal(histories_before + 1, histories_after)
    history = Person.find(2000).involvement_history.last
    campus_involvement = CampusInvolvement.find 1002
    assert_equal(Date.parse('2009-10-20'), history.start_date)
    assert_equal(Date.today, history.end_date)
  end
end
