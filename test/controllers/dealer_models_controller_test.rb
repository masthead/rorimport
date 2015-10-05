require 'test_helper'

class DealerModelsControllerTest < ActionController::TestCase
  setup do
    @dealer_model = dealer_models(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dealer_models)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dealer_model" do
    assert_difference('DealerModel.count') do
      post :create, dealer_model: { dealer_id: @dealer_model.dealer_id, vehicle_model_id: @dealer_model.vehicle_model_id }
    end

    assert_redirected_to dealer_model_path(assigns(:dealer_model))
  end

  test "should show dealer_model" do
    get :show, id: @dealer_model
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dealer_model
    assert_response :success
  end

  test "should update dealer_model" do
    patch :update, id: @dealer_model, dealer_model: { dealer_id: @dealer_model.dealer_id, vehicle_model_id: @dealer_model.vehicle_model_id }
    assert_redirected_to dealer_model_path(assigns(:dealer_model))
  end

  test "should destroy dealer_model" do
    assert_difference('DealerModel.count', -1) do
      delete :destroy, id: @dealer_model
    end

    assert_redirected_to dealer_models_path
  end
end
