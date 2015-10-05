require 'test_helper'

class SpecialInstructionsControllerTest < ActionController::TestCase
  setup do
    @special_instruction = special_instructions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:special_instructions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create special_instruction" do
    assert_difference('SpecialInstruction.count') do
      post :create, special_instruction: { dealer_id: @special_instruction.dealer_id, instruction_text: @special_instruction.instruction_text, special_instruction_type_id: @special_instruction.special_instruction_type_id }
    end

    assert_redirected_to special_instruction_path(assigns(:special_instruction))
  end

  test "should show special_instruction" do
    get :show, id: @special_instruction
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @special_instruction
    assert_response :success
  end

  test "should update special_instruction" do
    patch :update, id: @special_instruction, special_instruction: { dealer_id: @special_instruction.dealer_id, instruction_text: @special_instruction.instruction_text, special_instruction_type_id: @special_instruction.special_instruction_type_id }
    assert_redirected_to special_instruction_path(assigns(:special_instruction))
  end

  test "should destroy special_instruction" do
    assert_difference('SpecialInstruction.count', -1) do
      delete :destroy, id: @special_instruction
    end

    assert_redirected_to special_instructions_path
  end
end
