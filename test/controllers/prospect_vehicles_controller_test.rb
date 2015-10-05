require 'test_helper'

class ProspectVehiclesControllerTest < ActionController::TestCase
  setup do
    @prospect_vehicle = prospect_vehicles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prospect_vehicles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prospect_vehicle" do
    assert_difference('ProspectVehicle.count') do
      post :create, prospect_vehicle: { prospect_id: @prospect_vehicle.prospect_id, stock_number: @prospect_vehicle.stock_number, vehicle_make: @prospect_vehicle.vehicle_make, vehicle_model: @prospect_vehicle.vehicle_model, vehicle_year: @prospect_vehicle.vehicle_year, vin: @prospect_vehicle.vin }
    end

    assert_redirected_to prospect_vehicle_path(assigns(:prospect_vehicle))
  end

  test "should show prospect_vehicle" do
    get :show, id: @prospect_vehicle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prospect_vehicle
    assert_response :success
  end

  test "should update prospect_vehicle" do
    patch :update, id: @prospect_vehicle, prospect_vehicle: { prospect_id: @prospect_vehicle.prospect_id, stock_number: @prospect_vehicle.stock_number, vehicle_make: @prospect_vehicle.vehicle_make, vehicle_model: @prospect_vehicle.vehicle_model, vehicle_year: @prospect_vehicle.vehicle_year, vin: @prospect_vehicle.vin }
    assert_redirected_to prospect_vehicle_path(assigns(:prospect_vehicle))
  end

  test "should destroy prospect_vehicle" do
    assert_difference('ProspectVehicle.count', -1) do
      delete :destroy, id: @prospect_vehicle
    end

    assert_redirected_to prospect_vehicles_path
  end
end
