require 'test_helper'

class DealerMakesControllerTest < ActionController::TestCase
  setup do
    @dealer_make = dealer_makes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dealer_makes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dealer_make" do
    assert_difference('DealerMake.count') do
      post :create, dealer_make: { dealer_id: @dealer_make.dealer_id, vehicle_make_id: @dealer_make.vehicle_make_id }
    end

    assert_redirected_to dealer_make_path(assigns(:dealer_make))
  end

  test "should show dealer_make" do
    get :show, id: @dealer_make
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dealer_make
    assert_response :success
  end

  test "should update dealer_make" do
    patch :update, id: @dealer_make, dealer_make: { dealer_id: @dealer_make.dealer_id, vehicle_make_id: @dealer_make.vehicle_make_id }
    assert_redirected_to dealer_make_path(assigns(:dealer_make))
  end

  test "should destroy dealer_make" do
    assert_difference('DealerMake.count', -1) do
      delete :destroy, id: @dealer_make
    end

    assert_redirected_to dealer_makes_path
  end
end
