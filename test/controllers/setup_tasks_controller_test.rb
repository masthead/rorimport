require 'test_helper'

class SetupTasksControllerTest < ActionController::TestCase
  setup do
    @setup_task = setup_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:setup_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create setup_task" do
    assert_difference('SetupTask.count') do
      post :create, setup_task: { priority: @setup_task.priority, task_description: @setup_task.task_description }
    end

    assert_redirected_to setup_task_path(assigns(:setup_task))
  end

  test "should show setup_task" do
    get :show, id: @setup_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @setup_task
    assert_response :success
  end

  test "should update setup_task" do
    patch :update, id: @setup_task, setup_task: { priority: @setup_task.priority, task_description: @setup_task.task_description }
    assert_redirected_to setup_task_path(assigns(:setup_task))
  end

  test "should destroy setup_task" do
    assert_difference('SetupTask.count', -1) do
      delete :destroy, id: @setup_task
    end

    assert_redirected_to setup_tasks_path
  end
end
