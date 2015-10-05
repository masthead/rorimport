require 'test_helper'

class CallQueueUsersControllerTest < ActionController::TestCase
  setup do
    @call_queue_user = call_queue_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:call_queue_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call_queue_user" do
    assert_difference('CallQueueUser.count') do
      post :create, call_queue_user: { call_queue_id: @call_queue_user.call_queue_id, user_id: @call_queue_user.user_id }
    end

    assert_redirected_to call_queue_user_path(assigns(:call_queue_user))
  end

  test "should show call_queue_user" do
    get :show, id: @call_queue_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @call_queue_user
    assert_response :success
  end

  test "should update call_queue_user" do
    patch :update, id: @call_queue_user, call_queue_user: { call_queue_id: @call_queue_user.call_queue_id, user_id: @call_queue_user.user_id }
    assert_redirected_to call_queue_user_path(assigns(:call_queue_user))
  end

  test "should destroy call_queue_user" do
    assert_difference('CallQueueUser.count', -1) do
      delete :destroy, id: @call_queue_user
    end

    assert_redirected_to call_queue_users_path
  end
end
