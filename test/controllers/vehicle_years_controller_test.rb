require 'test_helper'

class VehicleYearsControllerTest < ActionController::TestCase
  setup do
    @vehicle_year = vehicle_years(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vehicle_years)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vehicle_year" do
    assert_difference('VehicleYear.count') do
      post :create, vehicle_year: { name: @vehicle_year.name }
    end

    assert_redirected_to vehicle_year_path(assigns(:vehicle_year))
  end

  test "should show vehicle_year" do
    get :show, id: @vehicle_year
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vehicle_year
    assert_response :success
  end

  test "should update vehicle_year" do
    patch :update, id: @vehicle_year, vehicle_year: { name: @vehicle_year.name }
    assert_redirected_to vehicle_year_path(assigns(:vehicle_year))
  end

  test "should destroy vehicle_year" do
    assert_difference('VehicleYear.count', -1) do
      delete :destroy, id: @vehicle_year
    end

    assert_redirected_to vehicle_years_path
  end
end
