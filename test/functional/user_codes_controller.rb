require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UserCodesController; def rescue_action(e) raise e end; end

class UserCodesControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    login
  end

  def test_show_found
    Factory(:user_code_1)
    login
    get :show, :code => 'code', :send_to_controller => 'c', :send_to_action => 'a'
    assert_redirected_to '/c/a'
  end

  def test_show_not_found
    Factory(:user_code_1)
    login
    get :show, :code => 'code-not-there'
    assert_equal('Sorry, no such code was found.', flash[:notice])
  end
end
