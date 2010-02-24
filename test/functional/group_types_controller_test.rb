require File.dirname(__FILE__) + '/../test_helper'

class GroupTypesControllerTest < ActionController::TestCase
  
  def setup
    setup_default_user
    Factory(:grouptype_1)
    Factory(:grouptype_2)
    Factory(:grouptype_3)
    login
  end

  test "should GET index with xml" do
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
    assert_response :success, @response.body
    assert_equal(Ministry.first.group_types.to_xml, @response.body)
  end
  
  test  "should GET new" do
    xhr :get, :new
    assert_response :success, @response.body
    assert_not_nil assigns(:group_type)
  end
  
  test  "should GET edit" do
    xhr :get, :edit, :id => 1
    assert_response :success, @response.body
    assert_not_nil assigns(:group_type)
  end
  
  test  "should create a new group type" do
    assert_difference("GroupType.count") do
      xhr :post, :create, :group_type => {:group_type => 'foo type'}
      assert_equal([], assigns(:group_type).errors.full_messages)
    end
    assert_response :success, @response.body
    assert_not_nil assigns(:group_type)
  end
  
  test  "should NOT create a new group type" do
    assert_no_difference("GroupType.count") do
      xhr :post, :create, :group_type => {:group_type => ''}
      assert_not_nil assigns(:group_type)
      assert_equal(1, assigns(:group_type).errors.length)
    end
    assert_response :success, @response.body
  end
  
  test  "should update a group type" do
    xhr :put, :update, :group_type => {:group_type => 'foo type'}, :id => 1
    gt = assigns(:group_type)
    assert_equal([], assigns(:group_type).errors.full_messages)
    assert_response :success, @response.body
  end
  
  test  "should NOT update a group type" do
    xhr :put, :update, :group_type => { :group_type => '' }, :id => 1
    assert_equal(1, assigns(:group_type).errors.length)
    assert_response :success, @response.body
  end
  
  test  "should remove a group type" do
    assert_difference("GroupType.count", -1) do
      xhr :delete, :destroy, :id => 2
    end
    assert_response :success, @response.body
  end
end
