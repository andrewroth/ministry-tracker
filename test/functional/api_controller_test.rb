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
    
    
    get :authorized, :a => 'directory', :c => 'people', :guid => '78ff7247-7b8f-4f42-8117-e03524fd1260'
    
    assert_response(401)
    assert_equal "<error><type>Authentication</type><message>API key not valid</message></error>", @response.body
    
    get :authorized, :a => 'directory', :c => 'people', :guid => '78ff7247-7b8f-4f42-8117-e03524fd1260', :api_key => '280ab349-bec3-4294-b77e-42045bb32b2e'
    
    assert_response :success
    assert_equal "<authorized action='directory' controller='people'>true</authorized>", @response.body
  end
  
  def test_ministry_involvements
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
    
    
    get :ministry_involvements, :guid => '78ff7247-7b8f-4f42-8117-e03524fd1260', :api_key => '280ab349-bec3-4294-b77e-42045bb32b2e'
    
    assert_response :success
  end
end
