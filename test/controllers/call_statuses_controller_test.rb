require 'test_helper'

class CallStatusesControllerTest < ActionController::TestCase
  setup do
    @call_status = call_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:call_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call_status" do
    assert_difference('CallStatus.count') do
      post :create, call_status: { status_name: @call_status.status_name }
    end

    assert_redirected_to call_status_path(assigns(:call_status))
  end

  test "should show call_status" do
    get :show, id: @call_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @call_status
    assert_response :success
  end

  test "should update call_status" do
    patch :update, id: @call_status, call_status: { status_name: @call_status.status_name }
    assert_redirected_to call_status_path(assigns(:call_status))
  end

  test "should destroy call_status" do
    assert_difference('CallStatus.count', -1) do
      delete :destroy, id: @call_status
    end

    assert_redirected_to call_statuses_path
  end
end
