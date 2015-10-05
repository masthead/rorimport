require 'test_helper'

class CampaignCustomersControllerTest < ActionController::TestCase
  setup do
    @campaign_customer = campaign_customers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_customers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_customer" do
    assert_difference('CampaignCustomer.count') do
      post :create, campaign_customer: {  }
    end

    assert_redirected_to campaign_customer_path(assigns(:campaign_customer))
  end

  test "should show campaign_customer" do
    get :show, id: @campaign_customer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_customer
    assert_response :success
  end

  test "should update campaign_customer" do
    patch :update, id: @campaign_customer, campaign_customer: {  }
    assert_redirected_to campaign_customer_path(assigns(:campaign_customer))
  end

  test "should destroy campaign_customer" do
    assert_difference('CampaignCustomer.count', -1) do
      delete :destroy, id: @campaign_customer
    end

    assert_redirected_to campaign_customers_path
  end
end
