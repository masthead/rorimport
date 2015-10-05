require 'test_helper'

class CampaignRunCustomersControllerTest < ActionController::TestCase
  setup do
    @campaign_run_customer = campaign_run_customers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_run_customers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_run_customer" do
    assert_difference('CampaignRunCustomer.count') do
      post :create, campaign_run_customer: { campaign_run_id: @campaign_run_customer.campaign_run_id, customer_id: @campaign_run_customer.customer_id, event_id: @campaign_run_customer.event_id }
    end

    assert_redirected_to campaign_run_customer_path(assigns(:campaign_run_customer))
  end

  test "should show campaign_run_customer" do
    get :show, id: @campaign_run_customer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_run_customer
    assert_response :success
  end

  test "should update campaign_run_customer" do
    patch :update, id: @campaign_run_customer, campaign_run_customer: { campaign_run_id: @campaign_run_customer.campaign_run_id, customer_id: @campaign_run_customer.customer_id, event_id: @campaign_run_customer.event_id }
    assert_redirected_to campaign_run_customer_path(assigns(:campaign_run_customer))
  end

  test "should destroy campaign_run_customer" do
    assert_difference('CampaignRunCustomer.count', -1) do
      delete :destroy, id: @campaign_run_customer
    end

    assert_redirected_to campaign_run_customers_path
  end
end
