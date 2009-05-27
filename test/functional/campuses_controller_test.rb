require File.dirname(__FILE__) + '/../test_helper'
require 'campuses_controller'

# Re-raise errors caught by the controller.
class CampusesController; def rescue_action(e) raise e end; end

class CampusesControllerTest < ActionController::TestCase
  fixtures :campuses
  fixtures :countries
  
  def setup
    login
  end

  test "change to invalid country" do
    xhr :post, :change_country, :country_id => nil
    # assert that the states returned have no items
    assert_equal 0, assigns['states'].count
    assert_response :success
  end
  
  test "change to valid country" do
    xhr :post, :change_country, :country_id => countries(:usa).id
    assert assigns['states'].count > 0
    assert_response :success
  end
  
  test "change to invalid state" do
    xhr :post, :change_state, :state_id => nil
    assert_equal 0, assigns['campuses'].count
    assert_response :success
  end
  
  test "change to valid state" do
    xhr :post, :change_state, :state_id => states(:wyoming).id
    assert assigns['campuses'].count > 0
    assert_response :success 
  end
  
  def test_change_county
    xhr :post, :change_county, :county => 'DuPage'
    assert_response :success
  end

  def test_details
    xhr :post, :details, :id => 1
    assert_response :success
  end
  
end
