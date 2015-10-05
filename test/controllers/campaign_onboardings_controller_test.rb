require 'test_helper'

class CampaignOnboardingsControllerTest < ActionController::TestCase
  setup do
    @campaign_onboarding = campaign_onboardings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_onboardings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_onboarding" do
    assert_difference('CampaignOnboarding.count') do
      post :create, campaign_onboarding: { area_code: @campaign_onboarding.area_code, customer_criteria: @campaign_onboarding.customer_criteria, customers_stay_in_queue: @campaign_onboarding.customers_stay_in_queue, data_source: @campaign_onboarding.data_source, dealer_name: @campaign_onboarding.dealer_name, dealer_onboarding_id: @campaign_onboarding.dealer_onboarding_id, description: @campaign_onboarding.description, dispositions: @campaign_onboarding.dispositions, labor_types: @campaign_onboarding.labor_types, name: @campaign_onboarding.name, number_attempts: @campaign_onboarding.number_attempts, status: @campaign_onboarding.status, survey_template_id: @campaign_onboarding.survey_template_id, survey_template_notes: @campaign_onboarding.survey_template_notes, voicemail_message: @campaign_onboarding.voicemail_message }
    end

    assert_redirected_to campaign_onboarding_path(assigns(:campaign_onboarding))
  end

  test "should show campaign_onboarding" do
    get :show, id: @campaign_onboarding
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_onboarding
    assert_response :success
  end

  test "should update campaign_onboarding" do
    patch :update, id: @campaign_onboarding, campaign_onboarding: { area_code: @campaign_onboarding.area_code, customer_criteria: @campaign_onboarding.customer_criteria, customers_stay_in_queue: @campaign_onboarding.customers_stay_in_queue, data_source: @campaign_onboarding.data_source, dealer_name: @campaign_onboarding.dealer_name, dealer_onboarding_id: @campaign_onboarding.dealer_onboarding_id, description: @campaign_onboarding.description, dispositions: @campaign_onboarding.dispositions, labor_types: @campaign_onboarding.labor_types, name: @campaign_onboarding.name, number_attempts: @campaign_onboarding.number_attempts, status: @campaign_onboarding.status, survey_template_id: @campaign_onboarding.survey_template_id, survey_template_notes: @campaign_onboarding.survey_template_notes, voicemail_message: @campaign_onboarding.voicemail_message }
    assert_redirected_to campaign_onboarding_path(assigns(:campaign_onboarding))
  end

  test "should destroy campaign_onboarding" do
    assert_difference('CampaignOnboarding.count', -1) do
      delete :destroy, id: @campaign_onboarding
    end

    assert_redirected_to campaign_onboardings_path
  end
end
