require 'test_helper'

class CallReportsControllerTest < ActionController::TestCase
  setup do
    @call_report = call_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:call_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call_report" do
    assert_difference('CallReport.count') do
      post :create, call_report: {  }
    end

    assert_redirected_to call_report_path(assigns(:call_report))
  end

  test "should show call_report" do
    get :show, id: @call_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @call_report
    assert_response :success
  end

  test "should update call_report" do
    patch :update, id: @call_report, call_report: {  }
    assert_redirected_to call_report_path(assigns(:call_report))
  end

  test "should destroy call_report" do
    assert_difference('CallReport.count', -1) do
      delete :destroy, id: @call_report
    end

    assert_redirected_to call_reports_path
  end
end
