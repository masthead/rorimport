require 'test_helper'

class SurveyTemplateQuestionsControllerTest < ActionController::TestCase
  setup do
    @survey_template_question = survey_template_questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:survey_template_questions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survey_template_question" do
    assert_difference('SurveyTemplateQuestion.count') do
      post :create, survey_template_question: { order: @survey_template_question.order, question_text: @survey_template_question.question_text, question_type_id: @survey_template_question.question_type_id, survey_template_id: @survey_template_question.survey_template_id }
    end

    assert_redirected_to survey_template_question_path(assigns(:survey_template_question))
  end

  test "should show survey_template_question" do
    get :show, id: @survey_template_question
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey_template_question
    assert_response :success
  end

  test "should update survey_template_question" do
    patch :update, id: @survey_template_question, survey_template_question: { order: @survey_template_question.order, question_text: @survey_template_question.question_text, question_type_id: @survey_template_question.question_type_id, survey_template_id: @survey_template_question.survey_template_id }
    assert_redirected_to survey_template_question_path(assigns(:survey_template_question))
  end

  test "should destroy survey_template_question" do
    assert_difference('SurveyTemplateQuestion.count', -1) do
      delete :destroy, id: @survey_template_question
    end

    assert_redirected_to survey_template_questions_path
  end
end
