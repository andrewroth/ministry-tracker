require File.dirname(__FILE__) + '/../test_helper'


class EmailTemplatesControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    Factory(:correspondencetype_1)

    login
  end

  test "should get new" do
    get :new, :correspondence_type_id => 1
    assert_response :success
  end

  test "should create email_template" do
    assert_difference('EmailTemplate.count') do
      post :create, :email_template => { :outcome_type => 'NOW', :subject => 'Hello', :from => 'email@address.net', :body => 'Content' }, :correspondence_type_id => 1
    end

    assert_redirected_to correspondence_type_path(assigns(:correspondence_type))
  end
#
#  test "should show email_template" do
#    get :show, :id => email_templates(:one).to_param
#    assert_response :success
#  end
#
  test "should get edit" do
    get :edit, :id => email_templates(:one).to_param, :correspondence_type_id => 1
    assert_response :success
  end

  test "should update email_template" do
    put :update, :id => email_templates(:one).to_param, :email_template => { :outcome_type => 'NOW', :subject => 'Hello', :from => 'email@address.net', :body => 'Content' }, :correspondence_type_id => 1
    assert_redirected_to correspondence_type_path(assigns(:correspondence_type))
  end

  test "will destroy email_template" do
    assert_difference('EmailTemplate.count', -1) do
      delete :destroy, :id => email_templates(:one).to_param, :correspondence_type_id => 1
    end

    assert_redirected_to correspondence_type_path(assigns(:correspondence_type))
  end
end
