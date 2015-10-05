require 'test_helper'

class ReportEmailAddressesControllerTest < ActionController::TestCase
  setup do
    @report_email_address = report_email_addresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:report_email_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report_email_address" do
    assert_difference('ReportEmailAddress.count') do
      post :create, report_email_address: {  }
    end

    assert_redirected_to report_email_address_path(assigns(:report_email_address))
  end

  test "should show report_email_address" do
    get :show, id: @report_email_address
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @report_email_address
    assert_response :success
  end

  test "should update report_email_address" do
    patch :update, id: @report_email_address, report_email_address: {  }
    assert_redirected_to report_email_address_path(assigns(:report_email_address))
  end

  test "should destroy report_email_address" do
    assert_difference('ReportEmailAddress.count', -1) do
      delete :destroy, id: @report_email_address
    end

    assert_redirected_to report_email_addresses_path
  end
end
