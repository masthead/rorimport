require 'test_helper'

class CampaignSurveyAlertsControllerTest < ActionController::TestCase
  setup do
    @campaign_survey_alert = campaign_survey_alerts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_survey_alerts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_survey_alert" do
    assert_difference('CampaignSurveyAlert.count') do
      post :create, campaign_survey_alert: { campaign_id: @campaign_survey_alert.campaign_id, employee_id: @campaign_survey_alert.employee_id, send_email: @campaign_survey_alert.send_email, send_text: @campaign_survey_alert.send_text }
    end

    assert_redirected_to campaign_survey_alert_path(assigns(:campaign_survey_alert))
  end

  test "should show campaign_survey_alert" do
    get :show, id: @campaign_survey_alert
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_survey_alert
    assert_response :success
  end

  test "should update campaign_survey_alert" do
    patch :update, id: @campaign_survey_alert, campaign_survey_alert: { campaign_id: @campaign_survey_alert.campaign_id, employee_id: @campaign_survey_alert.employee_id, send_email: @campaign_survey_alert.send_email, send_text: @campaign_survey_alert.send_text }
    assert_redirected_to campaign_survey_alert_path(assigns(:campaign_survey_alert))
  end

  test "should destroy campaign_survey_alert" do
    assert_difference('CampaignSurveyAlert.count', -1) do
      delete :destroy, id: @campaign_survey_alert
    end

    assert_redirected_to campaign_survey_alerts_path
  end
end
