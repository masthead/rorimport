require 'test_helper'

class CallBacksControllerTest < ActionController::TestCase
  setup do
    @call_back = call_backs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:call_backs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call_back" do
    assert_difference('CallBack.count') do
      post :create, call_back: { callback_at: @call_back.callback_at, campaign_customer_id: @call_back.campaign_customer_id, completed_at: @call_back.completed_at, notes: @call_back.notes, user_id: @call_back.user_id }
    end

    assert_redirected_to call_back_path(assigns(:call_back))
  end

  test "should show call_back" do
    get :show, id: @call_back
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @call_back
    assert_response :success
  end

  test "should update call_back" do
    patch :update, id: @call_back, call_back: { callback_at: @call_back.callback_at, campaign_customer_id: @call_back.campaign_customer_id, completed_at: @call_back.completed_at, notes: @call_back.notes, user_id: @call_back.user_id }
    assert_redirected_to call_back_path(assigns(:call_back))
  end

  test "should destroy call_back" do
    assert_difference('CallBack.count', -1) do
      delete :destroy, id: @call_back
    end

    assert_redirected_to call_backs_path
  end
end
