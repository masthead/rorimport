require 'test_helper'

class CampaignRunsControllerTest < ActionController::TestCase
  setup do
    @campaign_run = campaign_runs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_runs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_run" do
    assert_difference('CampaignRun.count') do
      post :create, campaign_run: { campaign_id: @campaign_run.campaign_id }
    end

    assert_redirected_to campaign_run_path(assigns(:campaign_run))
  end

  test "should show campaign_run" do
    get :show, id: @campaign_run
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_run
    assert_response :success
  end

  test "should update campaign_run" do
    patch :update, id: @campaign_run, campaign_run: { campaign_id: @campaign_run.campaign_id }
    assert_redirected_to campaign_run_path(assigns(:campaign_run))
  end

  test "should destroy campaign_run" do
    assert_difference('CampaignRun.count', -1) do
      delete :destroy, id: @campaign_run
    end

    assert_redirected_to campaign_runs_path
  end
end
