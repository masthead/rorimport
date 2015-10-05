require 'test_helper'

class DealerYearsControllerTest < ActionController::TestCase
  setup do
    @dealer_year = dealer_years(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dealer_years)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dealer_year" do
    assert_difference('DealerYear.count') do
      post :create, dealer_year: { dealer_id: @dealer_year.dealer_id, vehicle_year_id: @dealer_year.vehicle_year_id }
    end

    assert_redirected_to dealer_year_path(assigns(:dealer_year))
  end

  test "should show dealer_year" do
    get :show, id: @dealer_year
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dealer_year
    assert_response :success
  end

  test "should update dealer_year" do
    patch :update, id: @dealer_year, dealer_year: { dealer_id: @dealer_year.dealer_id, vehicle_year_id: @dealer_year.vehicle_year_id }
    assert_redirected_to dealer_year_path(assigns(:dealer_year))
  end

  test "should destroy dealer_year" do
    assert_difference('DealerYear.count', -1) do
      delete :destroy, id: @dealer_year
    end

    assert_redirected_to dealer_years_path
  end
end
