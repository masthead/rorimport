require 'test_helper'

class SaleDataControllerTest < ActionController::TestCase
  setup do
    @sale_datum = sale_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sale_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale_datum" do
    assert_difference('SaleDatum.count') do
      post :create, sale_datum: {  }
    end

    assert_redirected_to sale_datum_path(assigns(:sale_datum))
  end

  test "should show sale_datum" do
    get :show, id: @sale_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sale_datum
    assert_response :success
  end

  test "should update sale_datum" do
    patch :update, id: @sale_datum, sale_datum: {  }
    assert_redirected_to sale_datum_path(assigns(:sale_datum))
  end

  test "should destroy sale_datum" do
    assert_difference('SaleDatum.count', -1) do
      delete :destroy, id: @sale_datum
    end

    assert_redirected_to sale_data_path
  end
end
