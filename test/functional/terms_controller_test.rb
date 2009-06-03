require 'test_helper'

class TermsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:terms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create term" do
    assert_difference('Term.count') do
      post :create, :term => { }
    end

    assert_redirected_to term_path(assigns(:term))
  end

  test "should show term" do
    get :show, :id => terms(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => terms(:one).to_param
    assert_response :success
  end

  test "should update term" do
    put :update, :id => terms(:one).to_param, :term => { }
    assert_redirected_to term_path(assigns(:term))
  end

  test "should destroy term" do
    assert_difference('Term.count', -1) do
      delete :destroy, :id => terms(:one).to_param
    end

    assert_redirected_to terms_path
  end
end
