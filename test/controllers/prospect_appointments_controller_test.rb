require 'test_helper'

class ProspectAppointmentsControllerTest < ActionController::TestCase
  setup do
    @prospect_appointment = prospect_appointments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prospect_appointments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prospect_appointment" do
    assert_difference('ProspectAppointment.count') do
      post :create, prospect_appointment: { appointment_datetime: @prospect_appointment.appointment_datetime, is_shown: @prospect_appointment.is_shown, prospect_id: @prospect_appointment.prospect_id }
    end

    assert_redirected_to prospect_appointment_path(assigns(:prospect_appointment))
  end

  test "should show prospect_appointment" do
    get :show, id: @prospect_appointment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prospect_appointment
    assert_response :success
  end

  test "should update prospect_appointment" do
    patch :update, id: @prospect_appointment, prospect_appointment: { appointment_datetime: @prospect_appointment.appointment_datetime, is_shown: @prospect_appointment.is_shown, prospect_id: @prospect_appointment.prospect_id }
    assert_redirected_to prospect_appointment_path(assigns(:prospect_appointment))
  end

  test "should destroy prospect_appointment" do
    assert_difference('ProspectAppointment.count', -1) do
      delete :destroy, id: @prospect_appointment
    end

    assert_redirected_to prospect_appointments_path
  end
end
