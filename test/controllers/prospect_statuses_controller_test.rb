require 'test_helper'

class ProspectStatusesControllerTest < ActionController::TestCase
  setup do
    @prospect_status = prospect_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prospect_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prospect_status" do
    assert_difference('ProspectStatus.count') do
      post :create, prospect_status: { prospect_status_name: @prospect_status.prospect_status_name }
    end

    assert_redirected_to prospect_status_path(assigns(:prospect_status))
  end

  test "should show prospect_status" do
    get :show, id: @prospect_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prospect_status
    assert_response :success
  end

  test "should update prospect_status" do
    patch :update, id: @prospect_status, prospect_status: { prospect_status_name: @prospect_status.prospect_status_name }
    assert_redirected_to prospect_status_path(assigns(:prospect_status))
  end

  test "should destroy prospect_status" do
    assert_difference('ProspectStatus.count', -1) do
      delete :destroy, id: @prospect_status
    end

    assert_redirected_to prospect_statuses_path
  end
end
