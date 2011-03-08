require File.dirname(__FILE__) + '/../test_helper'

class SignupControllerTest < ActionController::TestCase

  def setup
    setup_genders
    setup_campuses
    setup_ministries
    setup_ministry_campuses
    setup_school_years
    setup_groups
    setup_people
    setup_users
    setup_semesters
    setup_weeks
    setup_years
  end

  test "index" do
    get :index
    assert_redirected_to :controller => "signup", :action => "step1_info"
  end

  test "step1_info" do
    get :step1_info

    assert_not_nil assigns(:person)
    assert_not_nil assigns(:primary_campus_involvement)

    assert_nil session[:signup_person_params]
    assert_nil session[:signup_primary_campus_involvement_params]
    assert_nil session[:signup_person_id]
    assert_nil session[:signup_campus_id]
    assert_nil session[:needs_verification]
    assert_nil session[:code_valid_for_user_id]
    assert_nil session[:code_valid_for_person_id]
  end

  test "step1_info_submit" do
    post :step1_info_submit, {:person => {:local_phone => "111-111-1111", :gender => "1", :last_name => "leader", :email => "leader@future.com", :first_name => "future"}, :primary_campus_involvement => {:campus_id => "1", :school_year_id => "1"}}

    assert assigns(:person).errors.blank?
    assert assigns(:primary_campus_involvement).errors.blank?

    assert_equal "future", assigns(:person).first_name
    assert_equal "leader", assigns(:person).last_name
    assert_equal "leader@future.com", assigns(:person).email
    assert_equal 1, assigns(:person).gender_id

    assert_equal 1, assigns(:primary_campus_involvement).campus_id
    assert_equal 1, assigns(:primary_campus_involvement).school_year_id

    ci = assigns(:person).campus_involvements.find(:first, :conditions => { :campus_id => assigns(:primary_campus_involvement).campus_id })
    assert_equal Date.today, ci.start_date
    assert_equal 1, ci.ministry_id

    assert_equal "leader@future.com", assigns(:user).username
    assert_same assigns(:user), assigns(:person).user

    assert_redirected_to :controller => "signup", :action => "step2_group"
  end

  test "step2_group" do
    post :step1_info_submit, {:person => {:local_phone => "111-111-1111", :gender => "1", :last_name => "leader", :email => "leader@future.com", :first_name => "future"}, :primary_campus_involvement => {:campus_id => "1", :school_year_id => "1"}}
    get :step2_group

    assert_array_similarity [Factory(:group_1)], assigns(:groups1)
    assert_array_similarity [], assigns(:groups2)
  end

  test "step2_default_group" do
    post :step1_info_submit, {:person => {:local_phone => "111-111-1111", :gender => "1", :last_name => "leader", :email => "leader@future.com", :first_name => "future"}, :primary_campus_involvement => {:campus_id => "1", :school_year_id => "1"}}
    get :step2_group
    get :step2_default_group, {:semester_id => 14}

    assert_equal "UoCD interested in a Discipleship Group (DG) for Current Semester", assigns(:group).name
    gi = GroupInvolvement.all(:conditions => {:group_id => assigns(:group).id, :person_id => assigns(:person).id})
    assert gi.present?
    assert_equal "member", gi[0].level

    assert_redirected_to :controller => "signup", :action => "step3_timetable"
  end

  test "finished" do
    post :step1_info_submit, {:person => {:local_phone => "111-111-1111", :gender => "1", :last_name => "leader", :email => "leader@future.com", :first_name => "future"}, :primary_campus_involvement => {:campus_id => "1", :school_year_id => "1"}}
    get :step2_group
    get :step2_default_group, {:semester_id => 14}

    get :finished
    assert_response :redirect
  end

  test "person info validates first name" do
    # submit without first name
    post :step2_info_submit, {:person => {:local_phone => "(123) 456.7890", :gender => "1", :last_name => "leader", :email => "leader@future.com", :first_name => "", :local_dorm => ""},
                              :primary_campus_involvement => {:school_year_id => "1"}},
                             {:signup_campus_id => "1"}
    assert_equal false, assigns(:person).errors.empty?
  end

  test "person info validates last name" do
    # submit without last name
    post :step2_info_submit, {:person => {:local_phone => "(123) 456.7890", :gender => "1", :last_name => "", :email => "leader@future.com", :first_name => "future", :local_dorm => ""},
                              :primary_campus_involvement => {:school_year_id => "1"}},
                             {:signup_campus_id => "1"}
    assert_equal false, assigns(:person).errors.empty?
  end

  test "person info validates email" do
    # submit without email
    post :step2_info_submit, {:person => {:local_phone => "(123) 456.7890", :gender => "1", :last_name => "leader", :email => "", :first_name => "future", :local_dorm => ""},
                              :primary_campus_involvement => {:school_year_id => "1"}},
                             {:signup_campus_id => "1"}
    assert_equal false, assigns(:person).errors.empty?
  end

  test "person info validates phone" do
    # submit without phone
    post :step2_info_submit, {:person => {:local_phone => "", :gender => "1", :last_name => "leader", :email => "leader@future.com", :first_name => "future", :local_dorm => ""},
                              :primary_campus_involvement => {:school_year_id => "1"}},
                             {:signup_campus_id => "1"}
    assert_equal false, assigns(:person).errors.empty?
  end

  test "person info validates school year" do
    # submit without school year
    post :step2_info_submit, {:person => {:local_phone => "(123) 456.7890", :gender => "1", :last_name => "leader", :email => "leader@future.com", :first_name => "future", :local_dorm => ""},
                              :primary_campus_involvement => {:school_year_id => ""}},
                             {:signup_campus_id => "1"}
    assert_equal false, assigns(:person).errors.empty?
  end

  test "person info validation pass" do
    # submit with everything
    post :step2_info_submit, {:person => {:local_phone => "(123) 456.7890", :gender => "1", :last_name => "leader", :email => "leader@future.com", :first_name => "future", :local_dorm => ""},
                              :primary_campus_involvement => {:school_year_id => "1"}},
                             {:signup_campus_id => "1"}
    assert_equal true, assigns(:person).errors.empty?
  end


end
