require File.dirname(__FILE__) + '/../test_helper'

class EmailsControllerTest < ActionController::TestCase
  def setup
    login
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:emails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get new with entire search" do
    get :new, :entire_search => '1'
    assert_response :success
  end

  test "should create email" do
    assert_difference('Email.count') do
      post :create, :email => {:subject => 'test', :body => 'foo bar' }
    end
    assert_response :redirect
  end

  test "should NOT create email" do
    assert_no_difference('Email.count') do
      post :create, :email => {:subject => '', :body => 'foo bar' }
    end

    assert_response :success, @response.body
    assert_template :new
  end

  test "should show email" do
    get :show, :id => emails(:one).to_param
    assert_response :success
  end
end
