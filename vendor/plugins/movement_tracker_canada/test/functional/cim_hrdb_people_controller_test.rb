require 'test_helper'

class CimHrdbPeopleControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cim_hrdb_people)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cim_hrdb_person" do
    assert_difference('CimHrdbPerson.count') do
      post :create, :cim_hrdb_person => { }
    end

    assert_redirected_to cim_hrdb_person_path(assigns(:cim_hrdb_person))
  end

  test "should show cim_hrdb_person" do
    get :show, :id => cim_hrdb_people(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => cim_hrdb_people(:one).to_param
    assert_response :success
  end

  test "should update cim_hrdb_person" do
    put :update, :id => cim_hrdb_people(:one).to_param, :cim_hrdb_person => { }
    assert_redirected_to cim_hrdb_person_path(assigns(:cim_hrdb_person))
  end

  test "should destroy cim_hrdb_person" do
    assert_difference('CimHrdbPerson.count', -1) do
      delete :destroy, :id => cim_hrdb_people(:one).to_param
    end

    assert_redirected_to cim_hrdb_people_path
  end
end
