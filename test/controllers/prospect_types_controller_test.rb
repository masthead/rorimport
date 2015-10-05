require 'test_helper'

class ProspectTypesControllerTest < ActionController::TestCase
  setup do
    @prospect_type = prospect_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prospect_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prospect_type" do
    assert_difference('ProspectType.count') do
      post :create, prospect_type: { prospect_type_name: @prospect_type.prospect_type_name }
    end

    assert_redirected_to prospect_type_path(assigns(:prospect_type))
  end

  test "should show prospect_type" do
    get :show, id: @prospect_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prospect_type
    assert_response :success
  end

  test "should update prospect_type" do
    patch :update, id: @prospect_type, prospect_type: { prospect_type_name: @prospect_type.prospect_type_name }
    assert_redirected_to prospect_type_path(assigns(:prospect_type))
  end

  test "should destroy prospect_type" do
    assert_difference('ProspectType.count', -1) do
      delete :destroy, id: @prospect_type
    end

    assert_redirected_to prospect_types_path
  end
end
