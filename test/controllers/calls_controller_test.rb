require 'test_helper'

class CallsControllerTest < ActionController::TestCase
  setup do
    @call = calls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:calls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call" do
    assert_difference('Call.count') do
      post :create, call: { call_sid: @call.call_sid, called: @call.called, caller: @call.caller, direction: @call.direction, duration: @call.duration, end_time: @call.end_time, from_number: @call.from_number, phone_number_sid: @call.phone_number_sid, start_time: @call.start_time, twilio_recording_url: @call.twilio_recording_url, uri: @call.uri }
    end

    assert_redirected_to call_path(assigns(:call))
  end

  test "should show call" do
    get :show, id: @call
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @call
    assert_response :success
  end

  test "should update call" do
    patch :update, id: @call, call: { call_sid: @call.call_sid, called: @call.called, caller: @call.caller, direction: @call.direction, duration: @call.duration, end_time: @call.end_time, from_number: @call.from_number, phone_number_sid: @call.phone_number_sid, start_time: @call.start_time, twilio_recording_url: @call.twilio_recording_url, uri: @call.uri }
    assert_redirected_to call_path(assigns(:call))
  end

  test "should destroy call" do
    assert_difference('Call.count', -1) do
      delete :destroy, id: @call
    end

    assert_redirected_to calls_path
  end
end
