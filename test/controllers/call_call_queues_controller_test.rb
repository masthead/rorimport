require 'test_helper'

class CallCallQueuesControllerTest < ActionController::TestCase
  setup do
    @call_call_queue = call_call_queues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:call_call_queues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call_call_queue" do
    assert_difference('CallCallQueue.count') do
      post :create, call_call_queue: { agent_id: @call_call_queue.agent_id, call_id: @call_call_queue.call_id, call_queue_id: @call_call_queue.call_queue_id, priority: @call_call_queue.priority }
    end

    assert_redirected_to call_call_queue_path(assigns(:call_call_queue))
  end

  test "should show call_call_queue" do
    get :show, id: @call_call_queue
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @call_call_queue
    assert_response :success
  end

  test "should update call_call_queue" do
    patch :update, id: @call_call_queue, call_call_queue: { agent_id: @call_call_queue.agent_id, call_id: @call_call_queue.call_id, call_queue_id: @call_call_queue.call_queue_id, priority: @call_call_queue.priority }
    assert_redirected_to call_call_queue_path(assigns(:call_call_queue))
  end

  test "should destroy call_call_queue" do
    assert_difference('CallCallQueue.count', -1) do
      delete :destroy, id: @call_call_queue
    end

    assert_redirected_to call_call_queues_path
  end
end
