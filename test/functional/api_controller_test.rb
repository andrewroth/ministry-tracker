require File.dirname(__FILE__) + '/../test_helper'

class ApiControllerTest < ActionController::TestCase

  def setup
    setup_users
    setup_api_keys
    Factory(:login_code_2)
  end

  def test_authorized
    setup_people
    Factory(:person_6)
    Factory(:person_2)
    setup_accesses
    setup_ministries
    setup_ministry_roles
    setup_ministry_involvements
    Factory(:permission_1)
    Factory(:permission_2)
    Factory(:permission_4)
    Factory(:ministryrolepermission_1)
    Factory(:ministryrolepermission_2)
    Factory(:ministryrolepermission_5)
    Factory(:ministryrolepermission_6)
    
    
    get :authorized, :a => 'directory', :c => 'people', :u => 'fred@uscm.org'
    
    assert_response :success
    assert_equal @response.body, "error"
    
    get :authorized, :a => 'directory', :c => 'people', :u => 'fred@uscm.org', :api_key => '280ab349-bec3-4294-b77e-42045bb32b2e'
    
    assert_response :success
    assert_equal @response.body, "true"
  end
end
