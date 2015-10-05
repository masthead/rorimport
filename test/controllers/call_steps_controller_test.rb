require 'test_helper'

class CallStepsControllerTest < ActionController::TestCase
  setup do
    @call_step = call_steps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:call_steps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call_step" do
    assert_difference('CallStep.count') do
      post :create, call_step: { agent_id: @call_step.agent_id, call_id: @call_step.call_id, call_status_id: @call_step.call_status_id }
    end

    assert_redirected_to call_step_path(assigns(:call_step))
  end

  test "should show call_step" do
    get :show, id: @call_step
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @call_step
    assert_response :success
  end

  test "should update call_step" do
    patch :update, id: @call_step, call_step: { agent_id: @call_step.agent_id, call_id: @call_step.call_id, call_status_id: @call_step.call_status_id }
    assert_redirected_to call_step_path(assigns(:call_step))
  end

  test "should destroy call_step" do
    assert_difference('CallStep.count', -1) do
      delete :destroy, id: @call_step
    end

    assert_redirected_to call_steps_path
  end
end
