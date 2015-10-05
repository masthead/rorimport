require 'test_helper'

class InvalidEmailsControllerTest < ActionController::TestCase
  setup do
    @invalid_email = invalid_emails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invalid_emails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invalid_email" do
    assert_difference('InvalidEmail.count') do
      post :create, invalid_email: { email_address: @invalid_email.email_address }
    end

    assert_redirected_to invalid_email_path(assigns(:invalid_email))
  end

  test "should show invalid_email" do
    get :show, id: @invalid_email
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invalid_email
    assert_response :success
  end

  test "should update invalid_email" do
    patch :update, id: @invalid_email, invalid_email: { email_address: @invalid_email.email_address }
    assert_redirected_to invalid_email_path(assigns(:invalid_email))
  end

  test "should destroy invalid_email" do
    assert_difference('InvalidEmail.count', -1) do
      delete :destroy, id: @invalid_email
    end

    assert_redirected_to invalid_emails_path
  end
end
