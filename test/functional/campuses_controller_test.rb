require File.dirname(__FILE__) + '/../test_helper'
require 'campuses_controller'

# Re-raise errors caught by the controller.
class CampusesController; def rescue_action(e) raise e end; end

class CampusesControllerTest < Test::Unit::TestCase
  fixtures Campus.table_name

  def setup
    @controller = CampusesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_change_country_with_states
    xhr :post, :change_country, :country => 'USA'
    assert_response :success
  end
  
  def test_change_country_without_states
    xhr :post, :change_country, :country => 'Kenya'
    assert_response :success
  end
  
  def test_change_state
    xhr :post, :change_state, :state => 'CA'
    assert_response :success
  end
  
  def test_change_county
    xhr :post, :change_county, :county => 'DuPage'
    assert_response :success
  end
end
