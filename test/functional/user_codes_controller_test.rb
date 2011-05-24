require File.dirname(__FILE__) + '/../test_helper'

class UserCodesControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    Factory(:login_code_1)
    Factory(:user_code_1)
    login
  end

end
