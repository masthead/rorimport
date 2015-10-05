require 'test_helper'

class VoiceMailsControllerTest < ActionController::TestCase
  setup do
    @voice_mail = voice_mails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:voice_mails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create voice_mail" do
    assert_difference('VoiceMail.count') do
      post :create, voice_mail: { attempt_number: @voice_mail.attempt_number, campaign_id: @voice_mail.campaign_id, voicemail_message: @voice_mail.voicemail_message }
    end

    assert_redirected_to voice_mail_path(assigns(:voice_mail))
  end

  test "should show voice_mail" do
    get :show, id: @voice_mail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @voice_mail
    assert_response :success
  end

  test "should update voice_mail" do
    patch :update, id: @voice_mail, voice_mail: { attempt_number: @voice_mail.attempt_number, campaign_id: @voice_mail.campaign_id, voicemail_message: @voice_mail.voicemail_message }
    assert_redirected_to voice_mail_path(assigns(:voice_mail))
  end

  test "should destroy voice_mail" do
    assert_difference('VoiceMail.count', -1) do
      delete :destroy, id: @voice_mail
    end

    assert_redirected_to voice_mails_path
  end
end
