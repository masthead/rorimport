require 'test_helper'

class VehicleMakesControllerTest < ActionController::TestCase
  setup do
    @vehicle_make = vehicle_makes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vehicle_makes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vehicle_make" do
    assert_difference('VehicleMake.count') do
      post :create, vehicle_make: { name: @vehicle_make.name }
    end

    assert_redirected_to vehicle_make_path(assigns(:vehicle_make))
  end

  test "should show vehicle_make" do
    get :show, id: @vehicle_make
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vehicle_make
    assert_response :success
  end

  test "should update vehicle_make" do
    patch :update, id: @vehicle_make, vehicle_make: { name: @vehicle_make.name }
    assert_redirected_to vehicle_make_path(assigns(:vehicle_make))
  end

  test "should destroy vehicle_make" do
    assert_difference('VehicleMake.count', -1) do
      delete :destroy, id: @vehicle_make
    end

    assert_redirected_to vehicle_makes_path
  end
end
