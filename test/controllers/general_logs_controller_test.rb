require 'test_helper'

class GeneralLogsControllerTest < ActionController::TestCase
  setup do
    @general_log = general_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:general_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create general_log" do
    assert_difference('GeneralLog.count') do
      post :create, general_log: { log_data: @general_log.log_data }
    end

    assert_redirected_to general_log_path(assigns(:general_log))
  end

  test "should show general_log" do
    get :show, id: @general_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @general_log
    assert_response :success
  end

  test "should update general_log" do
    patch :update, id: @general_log, general_log: { log_data: @general_log.log_data }
    assert_redirected_to general_log_path(assigns(:general_log))
  end

  test "should destroy general_log" do
    assert_difference('GeneralLog.count', -1) do
      delete :destroy, id: @general_log
    end

    assert_redirected_to general_logs_path
  end
end
