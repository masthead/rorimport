require 'test_helper'

class SurveyTemplateQuestionOptionsControllerTest < ActionController::TestCase
  setup do
    @survey_template_question_option = survey_template_question_options(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:survey_template_question_options)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survey_template_question_option" do
    assert_difference('SurveyTemplateQuestionOption.count') do
      post :create, survey_template_question_option: {  }
    end

    assert_redirected_to survey_template_question_option_path(assigns(:survey_template_question_option))
  end

  test "should show survey_template_question_option" do
    get :show, id: @survey_template_question_option
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey_template_question_option
    assert_response :success
  end

  test "should update survey_template_question_option" do
    patch :update, id: @survey_template_question_option, survey_template_question_option: {  }
    assert_redirected_to survey_template_question_option_path(assigns(:survey_template_question_option))
  end

  test "should destroy survey_template_question_option" do
    assert_difference('SurveyTemplateQuestionOption.count', -1) do
      delete :destroy, id: @survey_template_question_option
    end

    assert_redirected_to survey_template_question_options_path
  end
end
