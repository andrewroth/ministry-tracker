require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = Factory(:user_1)
  end

  def test_authenticate
    u = User.authenticate('josh.starcher@example.com', 'test')
    assert u.is_a?(User)
  end
  
  def test_new_password_validation
    @user.update_attributes(:plain_password => 'blahbas')
    assert_equal(1, @user.errors.size) # no mathing confirmation
    
    @user.update_attributes(:plain_password => 'blah', :password_confirmation => 'blah')
    assert_equal(1, @user.errors.size) # not long enough
    
    @user.update_attributes(:plain_password => 'blahblah', :password_confirmation => 'blahblah')
    assert_equal(0, @user.errors.size) # no errors
  end
  
  def test_user_token_nil
    assert !@user.remember_token?
  end
  
  def test_set_remember_me
    @user.remember_me
    assert @user.remember_token?
  end
  
  def test_forget_me
    test_set_remember_me
    @user.forget_me
    test_user_token_nil
  end
  
  def test_stamp_created_on
    u = User.create(:username => 'frank@uscm.org')
    assert_equal(0, u.errors.size)
    assert_not_nil u.created_at
  end
end
