require File.dirname(__FILE__) + '/../test_helper'
require 'profile_pictures_controller'

# Re-raise errors caught by the controller.
class ProfilePicturesController; def rescue_action(e) raise e end; end

class ProfilePicturesControllerTest < Test::Unit::TestCase
  fixtures Person.table_name, Ministry.table_name, MinistryCampus.table_name,
          CampusInvolvement.table_name, Address.table_name, Group.table_name,
          View.table_name, ViewColumn.table_name, Column.table_name, ProfilePicture.table_name

  def setup
    @controller = ProfilePicturesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  # def test_should_create_profile_picture
  #   assert_difference('ProfilePicture.count') do
  #     post :create, :profile_picture => { }
  #   end
  # 
  #   assert_redirected_to profile_picture_path(assigns(:profile_picture))
  # end

  def test_should_update_profile_picture
    put :update, :id => profile_pictures(:one).id, :profile_picture => { }
    assert_redirected_to person_path(assigns(:profile_picture).person)
  end
end
