require File.dirname(__FILE__) + '/../test_helper'
require 'profile_pictures_controller'

# Re-raise errors caught by the controller.
class ProfilePicturesController; def rescue_action(e) raise e end; end

class ProfilePicturesControllerTest < ActionController::TestCase
  fixtures Person.table_name, Ministry.table_name, MinistryCampus.table_name,
          CampusInvolvement.table_name, Address.table_name, Group.table_name,
          View.table_name, ViewColumn.table_name, Column.table_name, ProfilePicture.table_name

  def setup
    @controller = ProfilePicturesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  #If test fails, isntall image science as a gem
  def test_should_create_profile_picture
    image = fixture_file_upload('/files/rails.png', 'image/png')
    assert_difference('ProfilePicture.count', 4) do
      post :create, :profile_picture => {:uploaded_data => image },  :html => { :multipart => true }
    end
  
    assert_redirected_to person_path(assigns(:profile_picture).person)
  end

  def test_should_update_profile_picture
    image = fixture_file_upload('/files/rails.png', 'image/png')
    put :update, :id => profile_pictures(:one).id, :profile_picture => {:uploaded_data => image  }
    assert picture = assigns(:profile_picture)
    assert_equal([], picture.errors.full_messages)
    assert_redirected_to person_path(assigns(:profile_picture).person)
  end

  def test_should_NOT_update_profile_picture
    put :update, :id => profile_pictures(:one).id, :profile_picture => { }
    assert picture = assigns(:profile_picture)
    assert_equal(5, picture.errors.length)
    assert_redirected_to person_path(assigns(:profile_picture).person)
  end

  def test_should_delete_profile_picture
    xhr :post, :destroy, :id => profile_pictures(:one).id
    assert_response :success, @response.body
  end
end
