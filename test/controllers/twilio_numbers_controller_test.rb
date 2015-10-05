require 'test_helper'

class TwilioNumbersControllerTest < ActionController::TestCase
  setup do
    @twilio_number = twilio_numbers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:twilio_numbers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create twilio_number" do
    assert_difference('TwilioNumber.count') do
      post :create, twilio_number: { dealer_id: @twilio_number.dealer_id, is_active: @twilio_number.is_active, phone_number: @twilio_number.phone_number }
    end

    assert_redirected_to twilio_number_path(assigns(:twilio_number))
  end

  test "should show twilio_number" do
    get :show, id: @twilio_number
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @twilio_number
    assert_response :success
  end

  test "should update twilio_number" do
    patch :update, id: @twilio_number, twilio_number: { dealer_id: @twilio_number.dealer_id, is_active: @twilio_number.is_active, phone_number: @twilio_number.phone_number }
    assert_redirected_to twilio_number_path(assigns(:twilio_number))
  end

  test "should destroy twilio_number" do
    assert_difference('TwilioNumber.count', -1) do
      delete :destroy, id: @twilio_number
    end

    assert_redirected_to twilio_numbers_path
  end
end
