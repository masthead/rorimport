require 'test_helper'

class DealerOnboardingsControllerTest < ActionController::TestCase
  setup do
    @dealer_onboarding = dealer_onboardings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dealer_onboardings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dealer_onboarding" do
    assert_difference('DealerOnboarding.count') do
      post :create, dealer_onboarding: { address_1: @dealer_onboarding.address_1, address_2: @dealer_onboarding.address_2, city: @dealer_onboarding.city, departments: @dealer_onboarding.departments, employees: @dealer_onboarding.employees, name: @dealer_onboarding.name, notes: @dealer_onboarding.notes, postal_code: @dealer_onboarding.postal_code, state_province: @dealer_onboarding.state_province, status: @dealer_onboarding.status }
    end

    assert_redirected_to dealer_onboarding_path(assigns(:dealer_onboarding))
  end

  test "should show dealer_onboarding" do
    get :show, id: @dealer_onboarding
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dealer_onboarding
    assert_response :success
  end

  test "should update dealer_onboarding" do
    patch :update, id: @dealer_onboarding, dealer_onboarding: { address_1: @dealer_onboarding.address_1, address_2: @dealer_onboarding.address_2, city: @dealer_onboarding.city, departments: @dealer_onboarding.departments, employees: @dealer_onboarding.employees, name: @dealer_onboarding.name, notes: @dealer_onboarding.notes, postal_code: @dealer_onboarding.postal_code, state_province: @dealer_onboarding.state_province, status: @dealer_onboarding.status }
    assert_redirected_to dealer_onboarding_path(assigns(:dealer_onboarding))
  end

  test "should destroy dealer_onboarding" do
    assert_difference('DealerOnboarding.count', -1) do
      delete :destroy, id: @dealer_onboarding
    end

    assert_redirected_to dealer_onboardings_path
  end
end
