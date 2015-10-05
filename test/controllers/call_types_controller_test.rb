require 'test_helper'

class CallTypesControllerTest < ActionController::TestCase
  setup do
    @call_type = call_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:call_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call_type" do
    assert_difference('CallType.count') do
      post :create, call_type: { default_price: @call_type.default_price, type_name: @call_type.type_name }
    end

    assert_redirected_to call_type_path(assigns(:call_type))
  end

  test "should show call_type" do
    get :show, id: @call_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @call_type
    assert_response :success
  end

  test "should update call_type" do
    patch :update, id: @call_type, call_type: { default_price: @call_type.default_price, type_name: @call_type.type_name }
    assert_redirected_to call_type_path(assigns(:call_type))
  end

  test "should destroy call_type" do
    assert_difference('CallType.count', -1) do
      delete :destroy, id: @call_type
    end

    assert_redirected_to call_types_path
  end
end
