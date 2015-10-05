require 'test_helper'

class DealerCallTypesControllerTest < ActionController::TestCase
  setup do
    @dealer_call_type = dealer_call_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dealer_call_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dealer_call_type" do
    assert_difference('DealerCallType.count') do
      post :create, dealer_call_type: { call_type_id: @dealer_call_type.call_type_id, dealer_id: @dealer_call_type.dealer_id, price: @dealer_call_type.price }
    end

    assert_redirected_to dealer_call_type_path(assigns(:dealer_call_type))
  end

  test "should show dealer_call_type" do
    get :show, id: @dealer_call_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dealer_call_type
    assert_response :success
  end

  test "should update dealer_call_type" do
    patch :update, id: @dealer_call_type, dealer_call_type: { call_type_id: @dealer_call_type.call_type_id, dealer_id: @dealer_call_type.dealer_id, price: @dealer_call_type.price }
    assert_redirected_to dealer_call_type_path(assigns(:dealer_call_type))
  end

  test "should destroy dealer_call_type" do
    assert_difference('DealerCallType.count', -1) do
      delete :destroy, id: @dealer_call_type
    end

    assert_redirected_to dealer_call_types_path
  end
end
