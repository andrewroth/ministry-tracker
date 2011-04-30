require 'test_helper'

class SummerReportsControllerTest < ActionController::TestCase

  include SemesterSet

  def setup
    setup_years
    setup_months
    setup_weeks
    set_current_and_next_semester(true)
    setup_users
    setup_people
    setup_default_user
    setup_summer_reports

    login
  end

  test "should get index" do
    Factory(:summer_report_1)
    get :index
    assert_response :success
    assert_not_nil assigns(:current_year)
    assert_not_nil assigns(:num_reports_to_review)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create summer_report" do
    assert_difference('SummerReport.count') do
      post :create, "summer_report"=>{
        "support_coach"=>"true",
        "joined_staff"=>"1800",
        "notes"=>"...note!",
        "days_of_holiday"=>"30",
        "summer_report_reviewers_attributes"=>{
          "0"=>{"person_id"=>"2000"}
        },
        "num_weeks_of_mpm"=>"2",
        "monthly_goal"=>"1000",
        "monthly_have"=>"999",
        "num_weeks_of_mpd"=>"1",
        "monthly_needed"=>"1",
        "accountability_partner"=>"Batman",
        "summer_report_weeks_attributes"=>{
          "0"=>{"summer_report_assignment_id"=>"1", "description"=>"week 1 description", "week_id"=>"1"},
          "1"=>{"summer_report_assignment_id"=>"1", "description"=>"", "week_id"=>"2"},
          "2"=>{"summer_report_assignment_id"=>"1", "description"=>"", "week_id"=>"3"},
          "3"=>{"summer_report_assignment_id"=>"1", "description"=>"", "week_id"=>"4"},
          "4"=>{"summer_report_assignment_id"=>"1", "description"=>"", "week_id"=>"5"},
          "5"=>{"summer_report_assignment_id"=>"1", "description"=>"", "week_id"=>"6"},
          "6"=>{"summer_report_assignment_id"=>"2", "description"=>"", "week_id"=>"7"},
          "7"=>{"summer_report_assignment_id"=>"2", "description"=>"", "week_id"=>"8"},
          "8"=>{"summer_report_assignment_id"=>"2", "description"=>"", "week_id"=>"9"},
          "9"=>{"summer_report_assignment_id"=>"2", "description"=>"week 10 description", "week_id"=>"10"},
          "10"=>{"summer_report_assignment_id"=>"2", "description"=>"", "week_id"=>"11"},
          "11"=>{"summer_report_assignment_id"=>"2", "description"=>"", "week_id"=>"12"},
          "12"=>{"summer_report_assignment_id"=>"2", "description"=>"", "week_id"=>"13"},
          "13"=>{"summer_report_assignment_id"=>"2", "description"=>"", "week_id"=>"14"},
          "14"=>{"summer_report_assignment_id"=>"1", "description"=>"week 15 description", "week_id"=>"15"},
        }
      }
    end
  end

  test "should show summer_report" do
    sr = Factory(:summer_report_1)
    get :show, :id => sr.id
    assert_response :success
  end

  test "should update summer_report" do
    sr = Factory(:summer_report_1)
    put :update, :id => sr.id, :summer_report => {  }
    assert_redirected_to :controller => :summer_reports, :action => :index
  end

  test "search for reviewers" do
    setup_campuses
    setup_ministries
    setup_ministry_roles
    setup_ministry_involvements
    setup_ministry_campuses
    post :search_for_reviewers, :q => "josh"
    assert_equal 1, assigns(:people).size
  end

  test "report staff answers" do
    setup_ministries
    setup_ministry_roles
    setup_ministry_involvements
    sr = Factory(:summer_report_1)

    get :report_staff_answers, :summer_report_ministry => 2

    assert_not_nil assigns(:summer_reports)
    assert_equal sr.id, assigns(:summer_reports).first.id
  end

  test "report compliance" do
    setup_ministries
    setup_ministry_roles
    setup_ministry_involvements
    Factory(:person_6)
    p2 = Factory(:person_2)
    p7 = Factory(:person_7)
    Factory(:ministryinvolvement_6)
    Factory(:ministryinvolvement_3)
    sr = Factory(:summer_report_1)

    get :report_compliance

    assert_equal sr.id, assigns(:approved_reports).first.id
    assert_equal 0, assigns(:disapproved_reports).size
    assert_equal 0, assigns(:waiting_reports).size

    assert_not_nil assigns(:not_submitted_people)
    assert_nil assigns(:not_submitted_people).index(sr.person)
    assert_not_nil assigns(:not_submitted_people).index(p2)
    assert_not_nil assigns(:not_submitted_people).index(p7)
  end
end
