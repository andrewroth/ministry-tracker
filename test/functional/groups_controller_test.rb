require File.dirname(__FILE__) + '/../test_helper'

class GroupsControllerTest < ActionController::TestCase
 
  def setup
    setup_default_user
    setup_groups

    login
  end

  def test_index
    get :index
    assert_response :success
    assert_equal [ Factory.build(:group_1), Factory.build(:group_2) ], assigns('groups')
  end

  def test_join
    get :join
    assert_response :success
    assert_equal [ Factory.build(:group_1), Factory.build(:group_2) ], assigns('groups')
  end

  def test_join_request_campus_chosen
    p = Person.find 50000
    p.campus_involvements.delete_all
    get :join
    assert_response :success
  end

  # 
  # def test_index_xhr
  #   login
  #   xhr :get, :index
  #   assert_response :success
  # end
  
  def test_show
    login
    xhr :get, :show, :id => 2
    assert assigns(:group)
    assert_response :success
    assert_template('show')
  end
  
  def test_edit
    login
    xhr :get, :edit, :id => 2
    assert assigns(:group)
    assert_response :success
    assert_template('edit')
  end
  
  def test_update
    login
    xhr :put, :update, :id => 2, :group => {:name => "Frosh", }
    assert bs = assigns(:group)
    assert_equal bs.name, "Frosh"
    assert_response :success
    assert_template('update')
  end
  
  def test_should_get_new
    login
    xhr(:get, :new)
    assert_response :success
  end
  
  def test_should_get_new_and_post_and_create
    login
    session[:group] = nil
    assert_difference("Group.count") do
      xhr(:get, :new)
      assert_response :success
      post :create, :group => {:name => 'Water Water Water', :address => 'here', :city => 'there', 
                                :state => 'IL', :country => 'United States',
                                :email => 'asdf', :group_type_id => 1 }    
    end
    assert_not_nil assigns(:group) 
  end
  
  def test_create_with_members
    Factory(:person_2)
    Factory(:person_3)
    login
    old_count = Group.count
    post :create, :group => {:name => 'CCC', :address => 'here', :city => 'there',
                                :state => 'IL', :country => 'United States',
                                :email => 'asdf', :group_type_id => 1 },
                                :person => [2000, 3000]
    assert_equal old_count+1, Group.count
    assert_equal(2, Group.last.members.size)
  end

  def test_create_leader
    login
    old_count = Group.count
    post :create, :group => {:name => 'CCC', :address => 'here', :city => 'there',
                                :state => 'IL', :country => 'United States',
                                :email => 'asdf', :group_type_id => 1 }, :isleader => "1"
    assert_equal old_count+1, Group.count
    assert_not_equal([], ::GroupInvolvement.all(:conditions => { :person_id => 50000, :group_id => Group.last.id }) )
  end
  
  def test_should_create
    login
    old_count = Group.count
    post :create, :group => {:name => 'CCC', :address => 'here', :city => 'there', 
                                :state => 'IL', :country => 'United States',
                                :email => 'asdf', :group_type_id => 1 }
    assert_equal old_count+1, Group.count
  end
  
  def test_should_NOT_create
    login
    old_count = Group.count
    post :create, :group => {:name => '' }, :isleader => '1'
    assert_equal old_count, Group.count
    assert_template 'new'
  end

  def test_delete
    login
    xhr :delete, :destroy, :id => 2
    assert_response :success
  end

  def test_compare_timetables
    login
    setup_timetables
    setup_people
    get :compare_timetables, :id => 3

    assigns["comparison_map"][1].each do |time_slot|
      sec = time_slot.first.first

      if sec >= 23400 and sec <=75600
        assert_equal([::Person.find(50000)], time_slot[sec]["bads"])
      end

      if sec >= 43200 and sec <= 50400
        assert_equal([::Person.find(2000)], time_slot[sec]["goods"])
      end
    end

    get :compare_timetables, :id => 3, :members => [2, 50, 50000, 2000]

    assigns["comparison_map"][1].each do |time_slot|
      sec = time_slot.first.first

      if sec >= 23400 and sec <=75600
        assert_equal([::Person.find(50000)], time_slot[sec]["bads"])
      end

      if sec >= 43200 and sec <= 50400
        assert_equal([::Person.find(2000)], time_slot[sec]["goods"])
      end
    end
  end

  def test_set_start_time
    get :set_start_time, :time => 59400, :day => 1, :id => 1
    assert_equal(59400, ::Group.find(1).start_time)
    assert_equal(1, ::Group.find(1).day)

    get :set_end_time, :time => 66600, :day => 1, :id => 1
    get :set_start_time, :time => 72000, :day => 1, :id => 1
    assert_equal(59400, ::Group.find(1).start_time)
    assert_equal(1, ::Group.find(1).day)
  end

  def test_set_end_time
    get :set_end_time, :time => 59400, :day => 4, :id => 1
    assert_equal(nil, ::Group.find(1).end_time)
    assert_equal(nil, ::Group.find(1).day)

    get :set_start_time, :time => 59400, :day => 4, :id => 1
    get :set_end_time, :time => 66600, :day => 4, :id => 1
    assert_equal(66600, ::Group.find(1).end_time)
    assert_equal(4, ::Group.find(1).day)

    get :set_end_time, :time => 43200, :day => 4, :id => 1
    assert_equal(59400, ::Group.find(1).start_time)
    assert_equal(4, ::Group.find(1).day)
  end

end
