require File.dirname(__FILE__) + '/../test_helper'
require 'campus_discipleship_controller'



class CampusDiscipleshipControllerTest < ActionController::TestCase

  def setup
    setup_years
    setup_months
  end

  def login_admin_user
    Factory(:user_1)
    Factory(:access_1)
    Factory(:person_1)
    Factory(:ministry_1)
    Factory(:ministryrole_1)
    # there's no factory with ministryinvolvement_setperson??? -AR Sept 12, 2011
    #Factory(:ministryinvolvement_setperson, :person_id => "50000")
    Factory(:campus_1)
    #Factory(:campusinvolvement_setperson, :person_id => "50000")
    
    login('josh.starcher@example.com')
  end
  
  def barebones_login_admin_user
    Factory(:user_1)
    Factory(:access_1)
    Factory(:person_1)
    Factory(:ministry_1)
    Factory(:ministryrole_1)
    
    login('josh.starcher@example.com')
  end
  
=begin
# this uses factories that were apparently never committed
  def load_two_discipleship_trees_plus_one_nonministry_tree
    
    # setup basic ministry
    ministry1 = Factory(:ministry_1)
    ministry2 = Factory(:ministry_2)
 
    # setup mentorship tree 1
    person1 = Factory(:person_mentor)
    person2 = Factory(:person_mentor)
    person3 = Factory(:person_mentor)

    ministryinv1 = Factory(:ministryinvolvement_mentorship_1)
    ministryinv2 = Factory(:ministryinvolvement_mentorship_1)
    ministryinv3 = Factory(:ministryinvolvement_mentorship_1)
    
    person3.person_mentor_id = person2.id
    person3.save!
    person2.person_mentor_id = person1.id
    person2.save!
    
     # setup mentorship tree 2
    person4 = Factory(:person_mentor)
    person5 = Factory(:person_mentor)
    person6 = Factory(:person_mentor)
    
    ministryinv4 = Factory(:ministryinvolvement_mentorship_1)
    ministryinv5 = Factory(:ministryinvolvement_mentorship_1)
    ministryinv6 = Factory(:ministryinvolvement_mentorship_1)
    
    person6.person_mentor_id = person4.id
    person6.save!
    person5.person_mentor_id = person4.id
    person5.save!   
    
     
     # setup mentorship tree 3    (test for this tree not to appear due to different campus involvements)
    person7 = Factory(:person_mentor)
    person8 = Factory(:person_mentor)
    person9 = Factory(:person_mentor)
    
    ministryinv7 = Factory(:ministryinvolvement_mentorship_2)
    ministryinv8 = Factory(:ministryinvolvement_mentorship_2)
    ministryinv9 = Factory(:ministryinvolvement_mentorship_2)
    
    person9.person_mentor_id = person8.id
    person9.save!
    person8.person_mentor_id = person7.id
    person8.save!      
    
    @person1 = person1
    @person2 = person2
    @person3 = person3
    @person4 = person4
    @person5 = person5
    @person6 = person6
    @person7 = person7
    @person8 = person8
    @person9 = person9
     
  end
=end
  
   
=begin
  test "should show minstry specific discipleship trees" do
    login_admin_user
    
    # NOTE: make sure role names in ('Team Leader','Ministry Leader') are not chosen for test persons 
    # because we're trying to emulate students (which only show up as tree root if mentor == NULL)
    
    load_two_discipleship_trees_plus_one_nonministry_tree
    
    get :show     # campus_discipleship, :action => 'show'

    assert_template :show
    assert_template :partial => '_discipleship_tree', :count => 2   # shouldn't have count == 3 trees
    assert_response :success   

  end
=end
  
=begin
  test "remove disciple from discipleship view" do
    login_admin_user
    
    # NOTE: make sure role names in ('Team Leader','Ministry Leader') are not chosen for test persons 
    # because we're trying to emulate students (which only show up as tree root if mentor == NULL)
    
    load_two_discipleship_trees_plus_one_nonministry_tree
    
    get :show     # campus_discipleship, :action => 'show'
    
    assert_template :show
    assert_template :partial => '_discipleship_tree', :count => 2   # shouldn't have count == 3 trees
    assert_response :success  

    assert_equal @person1.id, @person2.person_mentor_id  # ensure person 2 is mentee of person 1
    
    xhr :get, :remove_disciple, :id => @person2.id
    assert_response :redirect           
    
    assert_nil Person.find(@person2.id).person_mentor_id

  end
=end

  
end
