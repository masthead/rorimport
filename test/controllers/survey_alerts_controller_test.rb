require 'test_helper'

class SurveyAlertsControllerTest < ActionController::TestCase
  setup do
    @survey_alert = survey_alerts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:survey_alerts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survey_alert" do
    assert_difference('SurveyAlert.count') do
      post :create, survey_alert: { alert_json: @survey_alert.alert_json, alert_text: @survey_alert.alert_text, alert_type: @survey_alert.alert_type, dealer_id: @survey_alert.dealer_id, employee_id: @survey_alert.employee_id, user_id: @survey_alert.user_id }
    end

    assert_redirected_to survey_alert_path(assigns(:survey_alert))
  end

  test "should show survey_alert" do
    get :show, id: @survey_alert
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey_alert
    assert_response :success
  end

  test "should update survey_alert" do
    patch :update, id: @survey_alert, survey_alert: { alert_json: @survey_alert.alert_json, alert_text: @survey_alert.alert_text, alert_type: @survey_alert.alert_type, dealer_id: @survey_alert.dealer_id, employee_id: @survey_alert.employee_id, user_id: @survey_alert.user_id }
    assert_redirected_to survey_alert_path(assigns(:survey_alert))
  end

  test "should destroy survey_alert" do
    assert_difference('SurveyAlert.count', -1) do
      delete :destroy, id: @survey_alert
    end

    assert_redirected_to survey_alerts_path
  end
end
