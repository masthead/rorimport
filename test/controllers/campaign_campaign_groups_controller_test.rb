require 'test_helper'

class CampaignCampaignGroupsControllerTest < ActionController::TestCase
  setup do
    @campaign_campaign_group = campaign_campaign_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_campaign_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_campaign_group" do
    assert_difference('CampaignCampaignGroup.count') do
      post :create, campaign_campaign_group: {  }
    end

    assert_redirected_to campaign_campaign_group_path(assigns(:campaign_campaign_group))
  end

  test "should show campaign_campaign_group" do
    get :show, id: @campaign_campaign_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_campaign_group
    assert_response :success
  end

  test "should update campaign_campaign_group" do
    patch :update, id: @campaign_campaign_group, campaign_campaign_group: {  }
    assert_redirected_to campaign_campaign_group_path(assigns(:campaign_campaign_group))
  end

  test "should destroy campaign_campaign_group" do
    assert_difference('CampaignCampaignGroup.count', -1) do
      delete :destroy, id: @campaign_campaign_group
    end

    assert_redirected_to campaign_campaign_groups_path
  end
end
