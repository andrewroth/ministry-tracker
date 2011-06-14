require File.dirname(__FILE__) + '/../test_helper'

class GroupInvitationsControllerTest < ActionController::TestCase
  
  def setup
    setup_default_user
    setup_semesters
    setup_groups
    setup_users
    setup_accesses

    login
  end
  
  def test_new
    get :new, :group_id => 1
    assert assigns(:group)
    assert_response :success
  end
  
  def test_new_not_leader
    get :new, :group_id => 2
    assert assigns(:group)
    assert_response :redirect
  end
  
  def test_create_multiple_not_leader
    assert_no_difference 'GroupInvitation.count' do
      post :create_multiple, :group_id => 2, "group_invitations"=>{"0"=>{"email"=>"test@whatever.com"}}
    end
    assert assigns(:group)
    assert_response :redirect
  end
  
  def test_create_multiple_email_already_invited
    Factory(:group_invitation_1)
    assert_no_difference 'GroupInvitation.count' do
      post :create_multiple, :group_id => 1, "group_invitations"=>{"0"=>{"email"=>"somedude@email.com"}}
    end
    assert flash[:notice].include? GroupInvitationsController::ALREADY_INVITED_MSG
    assert assigns(:group)
    assert_response :redirect
  end
  
  def test_create_multiple_person_already_involved
    assert_no_difference 'GroupInvitation.count' do
      post :create_multiple, :group_id => 3, "group_invitations"=>{"0"=>{"email"=>"sue@student.org"}}
    end
    assert flash[:notice].include? GroupInvitationsController::ALREADY_INVOLVED_MSG
    assert assigns(:group)
    assert_response :redirect
  end
  
  def test_create_multiple_invalid_email
    assert_no_difference 'GroupInvitation.count' do
      post :create_multiple, :group_id => 3, "group_invitations"=>{"0"=>{"email"=>"thbbbbb"}}
    end
    assert flash[:notice].include? GroupInvitationsController::INVALID_EMAIL_MSG
    assert assigns(:group)
    assert_response :redirect
  end
  
  def test_create_multiple
    assert_difference 'GroupInvitation.count', 2 do
      post :create_multiple, :group_id => 1, "group_invitations"=>{"0"=>{"email"=>"test@testmail.com"}, "1"=>{"email"=>"sue@student.org"}}
    end
    
    gi = GroupInvitation.first(:conditions => {:recipient_email => "test@testmail.com"})
    assert gi
    assert_equal gi.group_id, 1
    assert_nil gi.recipient_person_id
    assert_equal gi.sender_person_id, 50000
    assert_nil gi.accepted
    assert_not_nil gi.login_code_id
    
    gi = GroupInvitation.first(:conditions => {:recipient_email => "sue@student.org"})
    assert gi
    assert_equal gi.group_id, 1
    assert_equal gi.recipient_person_id, 2000
    assert_equal gi.sender_person_id, 50000
    assert_nil gi.accepted
    assert_not_nil gi.login_code_id
    
    assert flash[:notice].include? GroupInvitationsController::INVITATION_SENT_MSG
    assert assigns(:group)
    assert_response :redirect
  end
  
  def test_accept_invitation
    gi = Factory(:group_invitation_1)
    get :accept, :group_id => gi.group_id, :id => gi.id, :login_code => gi.login_code.code
    
    assert assigns(:invitation)
    assert_equal assigns(:invitation).id, gi.id
    assert_equal session[:signup_group_invitation_id], gi.id
    
    assert session[:signup_groups]
    assert_equal session[:signup_groups][assigns(:invitation).group_id], GroupInvitation::GROUP_INVITE_LEVEL
    assert_equal session[:signup_campus_id], assigns(:invitation).group.campus.id
    
    assert_redirected_to :controller => :signup, :action => :step2_info
  end
  
  def test_decline_invitation
    gi = Factory(:group_invitation_1)
    get :decline, :group_id => gi.group_id, :id => gi.id, :login_code => gi.login_code.code
    
    assert assigns(:invitation)
    assert_equal assigns(:invitation).id, gi.id
    assert_equal session[:signup_group_invitation_id], gi.id
    
    assert_equal assigns(:invitation).accepted, false
    assert_equal assigns(:invitation).login_code.acceptable?, false
    
    assert_redirected_to :controller => :signup, :action => :step1_group, :campus_id => assigns(:invitation).group.campus_id
  end
  
  def test_list
    gi = Factory(:group_invitation_1)
    get :list, :group_id => gi.group_id, :id => gi.id, :login_code => gi.login_code.code
    
    assert assigns(:invitation)
    assert_equal assigns(:invitation).id, gi.id
    assert_equal session[:signup_group_invitation_id], gi.id
    
    assert_redirected_to :controller => :signup, :action => :step1_group, :campus_id => assigns(:invitation).group.campus_id
  end
  
  def test_invitation_responded_already
    gi = Factory(:group_invitation_1)
    get :decline, :group_id => gi.group_id, :id => gi.id, :login_code => gi.login_code.code
    
    get :accept, :group_id => gi.group_id, :id => gi.id, :login_code => gi.login_code.code
    
    assert_redirected_to :controller => :sessions, :action => :new
  end
  
  def test_has_login_code_after_creation
    gi = Factory(:group_invitation_1)
    
    assert gi
    assert gi.login_code_id
    assert gi.login_code.code
    assert_equal gi.login_code.acceptable, true
    assert_equal gi.login_code.times_used, 0
  end
  
  def test_existing_user_logged_in_from_login_code
    gi = Factory(:group_invitation_2)
    
    get :accept, :group_id => gi.group_id, :id => gi.id, :login_code => gi.login_code.code
    
    assert assigns(:current_user)
    assert_equal assigns(:current_user).person.id, gi.recipient_person_id
  end
end






