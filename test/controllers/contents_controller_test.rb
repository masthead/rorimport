require 'test_helper'

class ContentsControllerTest < ActionController::TestCase
  setup do
    @content = contents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create content" do
    assert_difference('Content.count') do
      post :create, content: { appointment_calls_definition: @content.appointment_calls_definition, appointments_set_definition: @content.appointments_set_definition, no_appointment_calls_definition: @content.no_appointment_calls_definition, no_appointment_set_definition: @content.no_appointment_set_definition, shown_customer_definition: @content.shown_customer_definition, shown_ro_definition: @content.shown_ro_definition, total_calls_definition: @content.total_calls_definition }
    end

    assert_redirected_to content_path(assigns(:content))
  end

  test "should show content" do
    get :show, id: @content
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @content
    assert_response :success
  end

  test "should update content" do
    patch :update, id: @content, content: { appointment_calls_definition: @content.appointment_calls_definition, appointments_set_definition: @content.appointments_set_definition, no_appointment_calls_definition: @content.no_appointment_calls_definition, no_appointment_set_definition: @content.no_appointment_set_definition, shown_customer_definition: @content.shown_customer_definition, shown_ro_definition: @content.shown_ro_definition, total_calls_definition: @content.total_calls_definition }
    assert_redirected_to content_path(assigns(:content))
  end

  test "should destroy content" do
    assert_difference('Content.count', -1) do
      delete :destroy, id: @content
    end

    assert_redirected_to contents_path
  end
end
