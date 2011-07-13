require 'test_helper'

class LabelPeopleControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:label_people)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create label_person" do
    assert_difference('LabelPerson.count') do
      post :create, :label_person => { }
    end

    assert_redirected_to label_person_path(assigns(:label_person))
  end

  test "should show label_person" do
    get :show, :id => label_people(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => label_people(:one).to_param
    assert_response :success
  end

  test "should update label_person" do
    put :update, :id => label_people(:one).to_param, :label_person => { }
    assert_redirected_to label_person_path(assigns(:label_person))
  end

  test "should destroy label_person" do
    assert_difference('LabelPerson.count', -1) do
      delete :destroy, :id => label_people(:one).to_param
    end

    assert_redirected_to label_people_path
  end
end
