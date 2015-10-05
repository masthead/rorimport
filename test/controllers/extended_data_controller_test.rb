require 'test_helper'

class ExtendedDataControllerTest < ActionController::TestCase
  setup do
    @extended_datum = extended_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:extended_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create extended_datum" do
    assert_difference('ExtendedDatum.count') do
      post :create, extended_datum: { extended_id: @extended_datum.extended_id, extended_type: @extended_datum.extended_type, key: @extended_datum.key, value: @extended_datum.value }
    end

    assert_redirected_to extended_datum_path(assigns(:extended_datum))
  end

  test "should show extended_datum" do
    get :show, id: @extended_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @extended_datum
    assert_response :success
  end

  test "should update extended_datum" do
    patch :update, id: @extended_datum, extended_datum: { extended_id: @extended_datum.extended_id, extended_type: @extended_datum.extended_type, key: @extended_datum.key, value: @extended_datum.value }
    assert_redirected_to extended_datum_path(assigns(:extended_datum))
  end

  test "should destroy extended_datum" do
    assert_difference('ExtendedDatum.count', -1) do
      delete :destroy, id: @extended_datum
    end

    assert_redirected_to extended_data_path
  end
end
