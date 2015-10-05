require 'test_helper'

class CriterionTypesControllerTest < ActionController::TestCase
  setup do
    @criterion_type = criterion_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:criterion_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create criterion_type" do
    assert_difference('CriterionType.count') do
      post :create, criterion_type: { name: @criterion_type.name }
    end

    assert_redirected_to criterion_type_path(assigns(:criterion_type))
  end

  test "should show criterion_type" do
    get :show, id: @criterion_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @criterion_type
    assert_response :success
  end

  test "should update criterion_type" do
    patch :update, id: @criterion_type, criterion_type: { name: @criterion_type.name }
    assert_redirected_to criterion_type_path(assigns(:criterion_type))
  end

  test "should destroy criterion_type" do
    assert_difference('CriterionType.count', -1) do
      delete :destroy, id: @criterion_type
    end

    assert_redirected_to criterion_types_path
  end
end
