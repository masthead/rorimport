require 'test_helper'

class SurveyTemplateQuestionTypesControllerTest < ActionController::TestCase
  setup do
    @survey_template_question_type = survey_template_question_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:survey_template_question_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survey_template_question_type" do
    assert_difference('SurveyTemplateQuestionType.count') do
      post :create, survey_template_question_type: {  }
    end

    assert_redirected_to survey_template_question_type_path(assigns(:survey_template_question_type))
  end

  test "should show survey_template_question_type" do
    get :show, id: @survey_template_question_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey_template_question_type
    assert_response :success
  end

  test "should update survey_template_question_type" do
    patch :update, id: @survey_template_question_type, survey_template_question_type: {  }
    assert_redirected_to survey_template_question_type_path(assigns(:survey_template_question_type))
  end

  test "should destroy survey_template_question_type" do
    assert_difference('SurveyTemplateQuestionType.count', -1) do
      delete :destroy, id: @survey_template_question_type
    end

    assert_redirected_to survey_template_question_types_path
  end
end
