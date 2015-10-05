require 'test_helper'

class SpecialInstructionTypesControllerTest < ActionController::TestCase
  setup do
    @special_instruction_type = special_instruction_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:special_instruction_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create special_instruction_type" do
    assert_difference('SpecialInstructionType.count') do
      post :create, special_instruction_type: { type_name: @special_instruction_type.type_name }
    end

    assert_redirected_to special_instruction_type_path(assigns(:special_instruction_type))
  end

  test "should show special_instruction_type" do
    get :show, id: @special_instruction_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @special_instruction_type
    assert_response :success
  end

  test "should update special_instruction_type" do
    patch :update, id: @special_instruction_type, special_instruction_type: { type_name: @special_instruction_type.type_name }
    assert_redirected_to special_instruction_type_path(assigns(:special_instruction_type))
  end

  test "should destroy special_instruction_type" do
    assert_difference('SpecialInstructionType.count', -1) do
      delete :destroy, id: @special_instruction_type
    end

    assert_redirected_to special_instruction_types_path
  end
end
