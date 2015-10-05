require 'test_helper'

class SurveyAttemptsControllerTest < ActionController::TestCase
  setup do
    @survey_attempt = survey_attempts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:survey_attempts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survey_attempt" do
    assert_difference('SurveyAttempt.count') do
      post :create, survey_attempt: { call_record_id: @survey_attempt.call_record_id, survey_id: @survey_attempt.survey_id }
    end

    assert_redirected_to survey_attempt_path(assigns(:survey_attempt))
  end

  test "should show survey_attempt" do
    get :show, id: @survey_attempt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey_attempt
    assert_response :success
  end

  test "should update survey_attempt" do
    patch :update, id: @survey_attempt, survey_attempt: { call_record_id: @survey_attempt.call_record_id, survey_id: @survey_attempt.survey_id }
    assert_redirected_to survey_attempt_path(assigns(:survey_attempt))
  end

  test "should destroy survey_attempt" do
    assert_difference('SurveyAttempt.count', -1) do
      delete :destroy, id: @survey_attempt
    end

    assert_redirected_to survey_attempts_path
  end
end
