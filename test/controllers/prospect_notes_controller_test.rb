require 'test_helper'

class ProspectNotesControllerTest < ActionController::TestCase
  setup do
    @prospect_note = prospect_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prospect_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prospect_note" do
    assert_difference('ProspectNote.count') do
      post :create, prospect_note: { notes: @prospect_note.notes, prospect_id: @prospect_note.prospect_id }
    end

    assert_redirected_to prospect_note_path(assigns(:prospect_note))
  end

  test "should show prospect_note" do
    get :show, id: @prospect_note
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prospect_note
    assert_response :success
  end

  test "should update prospect_note" do
    patch :update, id: @prospect_note, prospect_note: { notes: @prospect_note.notes, prospect_id: @prospect_note.prospect_id }
    assert_redirected_to prospect_note_path(assigns(:prospect_note))
  end

  test "should destroy prospect_note" do
    assert_difference('ProspectNote.count', -1) do
      delete :destroy, id: @prospect_note
    end

    assert_redirected_to prospect_notes_path
  end
end
