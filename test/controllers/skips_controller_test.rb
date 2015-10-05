require 'test_helper'

class SkipsControllerTest < ActionController::TestCase
  setup do
    @skip = skips(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:skips)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create skip" do
    assert_difference('Skip.count') do
      post :create, skip: { campaign_customer_id: @skip.campaign_customer_id, notes: @skip.notes, user_id: @skip.user_id }
    end

    assert_redirected_to skip_path(assigns(:skip))
  end

  test "should show skip" do
    get :show, id: @skip
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @skip
    assert_response :success
  end

  test "should update skip" do
    patch :update, id: @skip, skip: { campaign_customer_id: @skip.campaign_customer_id, notes: @skip.notes, user_id: @skip.user_id }
    assert_redirected_to skip_path(assigns(:skip))
  end

  test "should destroy skip" do
    assert_difference('Skip.count', -1) do
      delete :destroy, id: @skip
    end

    assert_redirected_to skips_path
  end
end
