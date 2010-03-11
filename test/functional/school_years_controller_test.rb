require File.dirname(__FILE__) + '/../test_helper'

class SchoolYearsControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    Factory(:schoolyear_1)
    Factory(:schoolyear_2)
    login
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:school_years)
  end

  test "should get new" do
    xhr :get, :new
    assert_response :success
  end

  test "should create school_year" do
    assert_difference('SchoolYear.count') do
      xhr :post, :create, :school_year => {:name => 'foo' }
    end
    assert_response :success, @response.body
  end

  test "should NOT create school_year" do
    assert_no_difference('SchoolYear.count') do
      xhr :post, :create, :school_year => {:name => '' }
    end
    assert_response :success, @response.body
  end

  test "should get edit" do
    xhr :get, :edit, :id => Factory.build(:schoolyear_1).to_param
    assert_response :success
  end

  test "should update school_year" do
    xhr :put, :update, :id => Factory.build(:schoolyear_1).to_param, :school_year => { :name => 'foo' }
    assert_response :success, @response.body
    assert_equal([], assigns(:school_year).errors.full_messages)
  end

  test "should NOT update school_year" do
    xhr :put, :update, :id => Factory.build(:schoolyear_1).to_param, :school_year => {:name => '' }
    assert_response :success, @response.body
    assert_equal(1, assigns(:school_year).errors.length)
  end

  test "should destroy school_year" do
    assert_difference('SchoolYear.count', -1) do
      xhr :delete, :destroy, :id => Factory.build(:schoolyear_1).to_param
    end

    assert_response :success, @response.body
  end
  
  test "should change the order of the school years" do
    first = SchoolYear.first
    xhr :post, :reorder, :school_years => ['2','1']
    assert_not_equal(first, SchoolYear.first)
  end
end
