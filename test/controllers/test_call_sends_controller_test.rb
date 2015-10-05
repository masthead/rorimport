require 'test_helper'

class TestCallSendsControllerTest < ActionController::TestCase
  setup do
    @test_call_send = test_call_sends(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:test_call_sends)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create test_call_send" do
    assert_difference('TestCallSend.count') do
      post :create, test_call_send: { email_addresses: @test_call_send.email_addresses, user_id: @test_call_send.user_id }
    end

    assert_redirected_to test_call_send_path(assigns(:test_call_send))
  end

  test "should show test_call_send" do
    get :show, id: @test_call_send
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @test_call_send
    assert_response :success
  end

  test "should update test_call_send" do
    patch :update, id: @test_call_send, test_call_send: { email_addresses: @test_call_send.email_addresses, user_id: @test_call_send.user_id }
    assert_redirected_to test_call_send_path(assigns(:test_call_send))
  end

  test "should destroy test_call_send" do
    assert_difference('TestCallSend.count', -1) do
      delete :destroy, id: @test_call_send
    end

    assert_redirected_to test_call_sends_path
  end
end
