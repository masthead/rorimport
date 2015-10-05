require 'test_helper'

class OnboardingNotesControllerTest < ActionController::TestCase
  setup do
    @onboarding_note = onboarding_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:onboarding_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create onboarding_note" do
    assert_difference('OnboardingNote.count') do
      post :create, onboarding_note: { note: @onboarding_note.note, onboarding_id: @onboarding_note.onboarding_id, onboarding_type: @onboarding_note.onboarding_type }
    end

    assert_redirected_to onboarding_note_path(assigns(:onboarding_note))
  end

  test "should show onboarding_note" do
    get :show, id: @onboarding_note
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @onboarding_note
    assert_response :success
  end

  test "should update onboarding_note" do
    patch :update, id: @onboarding_note, onboarding_note: { note: @onboarding_note.note, onboarding_id: @onboarding_note.onboarding_id, onboarding_type: @onboarding_note.onboarding_type }
    assert_redirected_to onboarding_note_path(assigns(:onboarding_note))
  end

  test "should destroy onboarding_note" do
    assert_difference('OnboardingNote.count', -1) do
      delete :destroy, id: @onboarding_note
    end

    assert_redirected_to onboarding_notes_path
  end
end
