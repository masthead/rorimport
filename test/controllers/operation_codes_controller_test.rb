require 'test_helper'

class OperationCodesControllerTest < ActionController::TestCase
  setup do
    @operation_code = operation_codes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:operation_codes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create operation_code" do
    assert_difference('OperationCode.count') do
      post :create, operation_code: { name: @operation_code.name, service_id: @operation_code.service_id }
    end

    assert_redirected_to operation_code_path(assigns(:operation_code))
  end

  test "should show operation_code" do
    get :show, id: @operation_code
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @operation_code
    assert_response :success
  end

  test "should update operation_code" do
    patch :update, id: @operation_code, operation_code: { name: @operation_code.name, service_id: @operation_code.service_id }
    assert_redirected_to operation_code_path(assigns(:operation_code))
  end

  test "should destroy operation_code" do
    assert_difference('OperationCode.count', -1) do
      delete :destroy, id: @operation_code
    end

    assert_redirected_to operation_codes_path
  end
end
