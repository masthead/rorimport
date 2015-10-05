require 'test_helper'

class CommunicationTypesControllerTest < ActionController::TestCase
  setup do
    @communication_type = communication_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:communication_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create communication_type" do
    assert_difference('CommunicationType.count') do
      post :create, communication_type: { type_name: @communication_type.type_name }
    end

    assert_redirected_to communication_type_path(assigns(:communication_type))
  end

  test "should show communication_type" do
    get :show, id: @communication_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @communication_type
    assert_response :success
  end

  test "should update communication_type" do
    patch :update, id: @communication_type, communication_type: { type_name: @communication_type.type_name }
    assert_redirected_to communication_type_path(assigns(:communication_type))
  end

  test "should destroy communication_type" do
    assert_difference('CommunicationType.count', -1) do
      delete :destroy, id: @communication_type
    end

    assert_redirected_to communication_types_path
  end
end
