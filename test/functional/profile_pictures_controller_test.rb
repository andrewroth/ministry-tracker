require File.dirname(__FILE__) + '/../test_helper'
require 'profile_pictures_controller'

# Re-raise errors caught by the controller.
class ProfilePicturesController; def rescue_action(e) raise e end; end

class ProfilePicturesControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    
    @controller = ProfilePicturesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  #If test fails, install image science as a gem
  def test_should_create_profile_picture
    image = fixture_file_upload('/files/rails.png', 'image/png')
    assert_difference('ProfilePicture.count', 4) do
      post :create, :profile_picture => {:uploaded_data => image },  :html => { :multipart => true }
    end
  
    assert_redirected_to person_path(assigns(:profile_picture).person)
  end
  
  def test_should_update_profile_picture
    image = fixture_file_upload('/files/rails.png', 'image/png')
    put :update, :id => Factory(:profilepicture_1).id, :profile_picture => {:uploaded_data => image  }
    assert picture = assigns(:profile_picture)
    assert_equal([], picture.errors.full_messages)
    assert_redirected_to person_path(assigns(:profile_picture).person)
  end

  def test_should_NOT_update_profile_picture
    put :update, :id => Factory(:profilepicture_1).id, :profile_picture => {:uploaded_data => fixture_file_upload('/files/foo.txt', 'application/txt') }
    assert picture = assigns(:profile_picture)
    assert_equal('There was a problem updating your profile picture.', flash[:warning])
    assert_equal(["Content type is not included in the list"], picture.errors.full_messages)
    assert_redirected_to person_path(assigns(:profile_picture).person)
  end

  def test_should_delete_profile_picture
    xhr :post, :destroy, :id => Factory(:profilepicture_1).id
    assert_response :success, @response.body
  end
end
