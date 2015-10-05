require 'test_helper'

class CustomerVehiclesControllerTest < ActionController::TestCase
  setup do
    @customer_vehicle = customer_vehicles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_vehicles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_vehicle" do
    assert_difference('CustomerVehicle.count') do
      post :create, customer_vehicle: {  }
    end

    assert_redirected_to customer_vehicle_path(assigns(:customer_vehicle))
  end

  test "should show customer_vehicle" do
    get :show, id: @customer_vehicle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer_vehicle
    assert_response :success
  end

  test "should update customer_vehicle" do
    patch :update, id: @customer_vehicle, customer_vehicle: {  }
    assert_redirected_to customer_vehicle_path(assigns(:customer_vehicle))
  end

  test "should destroy customer_vehicle" do
    assert_difference('CustomerVehicle.count', -1) do
      delete :destroy, id: @customer_vehicle
    end

    assert_redirected_to customer_vehicles_path
  end
end
