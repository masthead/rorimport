require 'test_helper'

class AgentStatusesControllerTest < ActionController::TestCase
  setup do
    @agent_status = agent_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:agent_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create agent_status" do
    assert_difference('AgentStatus.count') do
      post :create, agent_status: { status_name: @agent_status.status_name }
    end

    assert_redirected_to agent_status_path(assigns(:agent_status))
  end

  test "should show agent_status" do
    get :show, id: @agent_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @agent_status
    assert_response :success
  end

  test "should update agent_status" do
    patch :update, id: @agent_status, agent_status: { status_name: @agent_status.status_name }
    assert_redirected_to agent_status_path(assigns(:agent_status))
  end

  test "should destroy agent_status" do
    assert_difference('AgentStatus.count', -1) do
      delete :destroy, id: @agent_status
    end

    assert_redirected_to agent_statuses_path
  end
end
