require 'test_helper'

class CampusTermsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campus_terms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campus_term" do
    assert_difference('CampusTerm.count') do
      post :create, :campus_term => { }
    end

    assert_redirected_to campus_term_path(assigns(:campus_term))
  end

  test "should show campus_term" do
    get :show, :id => campus_terms(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => campus_terms(:one).to_param
    assert_response :success
  end

  test "should update campus_term" do
    put :update, :id => campus_terms(:one).to_param, :campus_term => { }
    assert_redirected_to campus_term_path(assigns(:campus_term))
  end

  test "should destroy campus_term" do
    assert_difference('CampusTerm.count', -1) do
      delete :destroy, :id => campus_terms(:one).to_param
    end

    assert_redirected_to campus_terms_path
  end
end
