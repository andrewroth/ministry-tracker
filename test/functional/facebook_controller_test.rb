require File.dirname(__FILE__) + '/../test_helper'

class FacebookControllerTest < ActionController::TestCase

  test "tabs" do
    get :tabs
    assert_response :success, @response.body
  end
  
  test "bible_studies" do
    get :bible_studies
    assert_response :success, @response.body
  end
  
  test "training" do
    get :training
    assert_response :success, @response.body
  end
  
  test "install" do
    get :install
    assert_response :success, @response.body
  end
  
  test "remove" do
    get :remove
    assert_response :success, @response.body
  end
end
