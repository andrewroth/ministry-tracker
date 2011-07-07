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
    Factory(:login_code_1)
    Factory(:user_code_1)
    login
    get :show, :code => '5a12855a-aa70-4990-b757-6bf02ec7a30b', :send_to_controller => 'c', :send_to_action => 'a'
    assert_redirected_to '/c/a'
  end

  def test_show_not_found
    Factory(:login_code_1)
    Factory(:user_code_1)
    login
    get :show, :code => 'code-not-there'
    assert_equal('Sorry, no such code was found.', flash[:notice])
  end
end
