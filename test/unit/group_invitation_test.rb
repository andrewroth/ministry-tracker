require File.dirname(__FILE__) + '/../test_helper'

class GroupInvitationTest < ActiveSupport::TestCase

  def test_accept
    gi = Factory(:group_invitation_1)
    
    gi.accept
    
    assert_equal gi.accepted, true
    assert_equal gi.login_code.acceptable?, false
  end
  
  def test_decline
    gi = Factory(:group_invitation_1)
    
    gi.decline
    
    assert_equal gi.accepted, false
    assert_equal gi.login_code.acceptable?, false
  end
  
  def test_has_response
    gi = Factory(:group_invitation_1)
    
    assert_equal gi.has_response?, false
    gi.accept
    assert_equal gi.has_response?, true
  end
  
  def test_has_login_code_after_creation
    gi = Factory(:group_invitation_1)
    
    assert gi
    assert gi.login_code_id
    assert gi.login_code.code
    assert_equal gi.login_code.acceptable, true
    assert_equal gi.login_code.times_used, 0
  end
  
end
