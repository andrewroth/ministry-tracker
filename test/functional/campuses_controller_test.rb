require File.dirname(__FILE__) + '/../test_helper'
require 'campuses_controller'

# Re-raise errors caught by the controller.
class CampusesController; def rescue_action(e) raise e end; end

class CampusesControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    setup_ministry_roles

    login
  end

  test "change to invalid country" do
    xhr :post, :change_country, :country_id => nil
    # assert that the states returned have no items
    assert_equal 0, assigns['states'].length
    assert_response :success
  end
  
  test "change to valid country" do
    xhr :post, :change_country, :country => 'US'
    assert assigns['states'].length > 0
    assert_response :success
  end
  
  test "change to invalid state" do
    xhr :post, :change_state, :state_id => nil
    assert_equal 0, assigns['campuses'].length
    assert_response :success
  end
  
  test "change to valid state" do
    xhr :post, :change_state, :country => 'US', :state => 'CA'
    assert assigns['campuses'].length > 0
    assert_response :success 
  end
  
  def test_change_country
    xhr :post, :change_country, :country => 'DuPage'
    assert_response :success
  end

  def test_details
    xhr :post, :details, :id => 1
    assert_response :success
  end
  
end
