require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'


# Re-raise errors caught by the controller.
class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < ActionController::TestCase
  def setup
  # TODO: if necessary
end

  def login_admin_user
    Factory(:user_1)
    Factory(:access_1)
    Factory(:person_1)
    Factory(:ministryrole_1)
    Factory(:ministryinvolvement_1)
    
    login('josh.starcher@example.com')
  end

  def setup_search_people
    
    #Person 6
    Factory(:person_6)
    Factory(:ministry_1)
    Factory(:ministryrole_3)
    Factory(:campus_1)
    Factory(:campusinvolvement_5)
    Factory(:ministryinvolvement_8)
    Factory(:profilepicture_6)
    Factory(:timetable_6)
    
    #Person 3
    Factory(:person_3)
    Factory(:ministryrole_6)
    Factory(:campusinvolvement_4) 
    Factory(:ministry_1)
    Factory(:campus_2)
    Factory(:ministryinvolvement_9)
    Factory(:profilepicture_30)
    Factory(:timetable_2)
    
    #Person 2
    Factory(:person_2)
    Factory(:ministryrole_6)
    Factory(:campusinvolvement_6) 
    Factory(:ministry_1)
    Factory(:campus_1)
    Factory(:ministryinvolvement_10)   
    Factory(:profilepicture_20)
    Factory(:timetable_3)
  end
  
  def test_general_quick_search_results
    
    setup_search_people  
    login_admin_user
    #get :setup_session_for_search
    xhr :get, :autocomplete, :q => '\'Ministry\''
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert_equal 1, ppl.size
    assert(ppl.detect {|p| p['person_id'].to_i == Factory(:person_6).id}, "person_6 showed up!")
  end  

  def test_no_self_in_mentor_results
    
    setup_search_people  
    login_admin_user
    #get :setup_session_for_search
    xhr :get, :autocomplete_mentors, :q => '\'Ministry\'', :p => Factory(:person_6).id
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert_equal 0, ppl.size

    xhr :get, :autocomplete_mentors, :q => 'sue', :p => Factory(:person_6).id
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert_equal 1, ppl.size
    assert(ppl.detect {|p| p['person_id'].to_i == Factory(:person_3).id}, "person_3 showed up!")
  
  end
  
  def test_no_mentee_in_mentor_results
    
    setup_search_people  
    login_admin_user
    #get :setup_session_for_search
    xhr :get, :autocomplete_mentors, :q => 'fred anderson', :p => Factory(:person_6).id
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert_equal 0, ppl.size
    
    xhr :get, :autocomplete_mentors, :q => 'sue', :p => Factory(:person_6).id
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert_equal 1, ppl.size
    assert(ppl.detect {|p| p['person_id'].to_i == Factory(:person_3).id}, "person_3 showed up!")
  end  
  
  def test_no_self_in_mentee_results
    
    setup_search_people  
    login_admin_user
    #get :setup_session_for_search
    xhr :get, :autocomplete_mentees, :q => '\'Ministry\'', :p => Factory(:person_6).id
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert_equal 0, ppl.size
    
    xhr :get, :autocomplete_mentees, :q => 'sue', :p => Factory(:person_6).id
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert_equal 1, ppl.size
    assert(ppl.detect {|p| p['person_id'].to_i == Factory(:person_3).id}, "person_3 showed up!")
  end 
  
  def test_no_mentor_in_mentee_results
    
    setup_search_people  
    login_admin_user
    #get :setup_session_for_search
    xhr :get, :autocomplete_mentees, :q => '\'Ministry\'', :p => Factory(:person_2).id
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert_equal 0, ppl.size
    
    xhr :get, :autocomplete_mentees, :q => 'sue', :p => Factory(:person_2).id
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert_equal 1, ppl.size
    assert(ppl.detect {|p| p['person_id'].to_i == Factory(:person_3).id}, "person_3 showed up!")
  end   
  
  def test_no_current_mentees_in_mentee_results
    
    setup_search_people  
    login_admin_user
    #get :setup_session_for_search
    xhr :get, :autocomplete_mentees, :q => 'fred anderson', :p => Factory(:person_1).id
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert_equal 0, ppl.size
    
    xhr :get, :autocomplete_mentees, :q => 'sue', :p => Factory(:person_1).id
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert_equal 1, ppl.size
    assert(ppl.detect {|p| p['person_id'].to_i == Factory(:person_3).id}, "person_3 showed up!")
  end    

end
