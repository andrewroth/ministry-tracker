require File.dirname(__FILE__) + '/../test_helper'

class ImportsControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    login
  end
  
  test "new" do
    get :new
    assert assigns(:import)
    assert_response :success
  end
  
  test "create" do
    file = fixture_file_upload('/files/sample_import.csv', 'text/csv')
    post :create, :import => {:uploaded_data => file},  :html => { :multipart => true }, :campus_id => Campus.first.id
    assert assigns(:import)
    # assert_equal(1, assigns(:successful))
    assert_response :redirect
    assert_redirected_to '/people/directory.html'
  end
  
  test "create from xls file" do
    file = fixture_file_upload('/files/sample_import.xls', 'application/xls')
    post :create, :import => {:uploaded_data => file},  :html => { :multipart => true }, :campus_id => Campus.first.id
    assert assigns(:import)
    # assert_equal(1, assigns(:successful))
    assert_response :redirect
    assert_redirected_to '/people/directory.html'
  end
    
   test "create with no good rows" do
     file = fixture_file_upload('/files/sample_import_bad.csv', 'text/csv')
     post :create, :import => {:uploaded_data => file},  :html => { :multipart => true }, :campus_id => Campus.first.id
     assert assigns(:import)
     # assert_equal(0, assigns(:successful))
     # assert_equal(1, assigns(:unsuccessful))
    assert_response :redirect
    assert_redirected_to '/people/directory.html'
   end
   
   test "create with one of each" do
     file = fixture_file_upload('/files/sample_import_one_of_each.csv', 'text/csv')
     post :create, :import => {:uploaded_data => file},  :html => { :multipart => true }, :campus_id => Campus.first.id
     assert assigns(:import)
     assert_response :redirect
     assert_redirected_to '/people/directory.html'
   end
end
