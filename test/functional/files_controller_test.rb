require File.dirname(__FILE__) + '/../test_helper'
require 'files_controller'
require 'uploads'

# Re-raise errors caught by the controller.
class FilesController; def rescue_action(e) raise e end; end

class FilesControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    @controller = FilesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  # def test_progress
  #   xhr :get, :progress
  #   assert_response :success
  # end
  # 
  # def test_person_image_upload
  #   post :upload, :person => {:image => fixture_file_upload("image.jpg", "image/jpg")}, :id => 50000
  #   assert_response :success
  # end
  # 
  # def test_generic_file_upload
  #   post :upload, "person['image']" => fixture_file_upload("image.jpg", "image/jpg")
  #   assert_response :success
  # end
end
