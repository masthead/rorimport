require 'test_helper'

class SystemStatsControllerTest < ActionController::TestCase
  setup do
    @system_stat = system_stats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:system_stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create system_stat" do
    assert_difference('SystemStat.count') do
      post :create, system_stat: {  }
    end

    assert_redirected_to system_stat_path(assigns(:system_stat))
  end

  test "should show system_stat" do
    get :show, id: @system_stat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @system_stat
    assert_response :success
  end

  test "should update system_stat" do
    patch :update, id: @system_stat, system_stat: {  }
    assert_redirected_to system_stat_path(assigns(:system_stat))
  end

  test "should destroy system_stat" do
    assert_difference('SystemStat.count', -1) do
      delete :destroy, id: @system_stat
    end

    assert_redirected_to system_stats_path
  end
end
