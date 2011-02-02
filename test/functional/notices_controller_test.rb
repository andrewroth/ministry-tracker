require File.dirname(__FILE__) + '/../test_helper'

class NoticesControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    @live_notice = Factory(:live_notice)
    @not_live_notice = Factory(:not_live_notice)
    login
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notice" do
    assert_difference('Notice.count') do
      post :create, :notice => {:message => 'foo', :live => true }
    end
    assert_response :redirect, @response.body
  end

  test "should NOT create notice" do
    assert_no_difference('Notice.count') do
      post :create, :notice => {:message => '' }
    end
    assert_response :success, @response.body
  end

  test "should get edit" do
    get :edit, :id => @live_notice.id
    assert_response :success
  end

  test "should update notice" do
    put :update, :id => @live_notice.id, :notice => { :message => "NEW MESSAGE" }
    assert_response :redirect, @response.body
    assert_equal([], assigns(:notice).errors.full_messages)
    assert_equal("NEW MESSAGE", assigns(:notice).message)
  end

  test "should NOT update notice" do
    put :update, :id => @live_notice.id, :notice => { :message => '' }
    assert_response :success, @response.body
    assert_equal(1, assigns(:notice).errors.length)
  end

  test "should destroy notice" do
    assert_difference('Notice.count', -1) do
      delete :destroy, :id => @live_notice.id
    end

    assert_response :redirect, @response.body
  end

  test "should show notice" do
    get :show, :id => @live_notice.id
    assert_response :success, @response.body
  end
   
  test "should dismiss notice" do
    setup_default_user
    login
    xhr :post, :dismiss, :id => @live_notice
    assert @person.dismissed_notices.find_by_notice_id(@live_notice.id).present?
  end
end
