require 'test_helper'

class LaborTypesControllerTest < ActionController::TestCase
  setup do
    @labor_type = labor_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:labor_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create labor_type" do
    assert_difference('LaborType.count') do
      post :create, labor_type: { dealer_id: @labor_type.dealer_id, name: @labor_type.name }
    end

    assert_redirected_to labor_type_path(assigns(:labor_type))
  end

  test "should show labor_type" do
    get :show, id: @labor_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @labor_type
    assert_response :success
  end

  test "should update labor_type" do
    patch :update, id: @labor_type, labor_type: { dealer_id: @labor_type.dealer_id, name: @labor_type.name }
    assert_redirected_to labor_type_path(assigns(:labor_type))
  end

  test "should destroy labor_type" do
    assert_difference('LaborType.count', -1) do
      delete :destroy, id: @labor_type
    end

    assert_redirected_to labor_types_path
  end
end
