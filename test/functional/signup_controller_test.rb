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
    assert_redirected_to :controller => "signup", :action => "step1_group"
  end

  test "step1_group" do
    get :step1_group
  end

  test "step2_default_group" do
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
