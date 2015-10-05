require 'test_helper'

class TwilioVoicesControllerTest < ActionController::TestCase
  setup do
    @twilio_voice = twilio_voices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:twilio_voices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create twilio_voice" do
    assert_difference('TwilioVoice.count') do
      post :create, twilio_voice: { incoming_params: @twilio_voice.incoming_params, twilio_number_id: @twilio_voice.twilio_number_id }
    end

    assert_redirected_to twilio_voice_path(assigns(:twilio_voice))
  end

  test "should show twilio_voice" do
    get :show, id: @twilio_voice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @twilio_voice
    assert_response :success
  end

  test "should update twilio_voice" do
    patch :update, id: @twilio_voice, twilio_voice: { incoming_params: @twilio_voice.incoming_params, twilio_number_id: @twilio_voice.twilio_number_id }
    assert_redirected_to twilio_voice_path(assigns(:twilio_voice))
  end

  test "should destroy twilio_voice" do
    assert_difference('TwilioVoice.count', -1) do
      delete :destroy, id: @twilio_voice
    end

    assert_redirected_to twilio_voices_path
  end
end
