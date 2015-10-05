require 'test_helper'

class ServiceSchedulersControllerTest < ActionController::TestCase
  setup do
    @service_scheduler = service_schedulers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:service_schedulers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service_scheduler" do
    assert_difference('ServiceScheduler.count') do
      post :create, service_scheduler: { login_url: @service_scheduler.login_url, scheduler_name: @service_scheduler.scheduler_name }
    end

    assert_redirected_to service_scheduler_path(assigns(:service_scheduler))
  end

  test "should show service_scheduler" do
    get :show, id: @service_scheduler
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @service_scheduler
    assert_response :success
  end

  test "should update service_scheduler" do
    patch :update, id: @service_scheduler, service_scheduler: { login_url: @service_scheduler.login_url, scheduler_name: @service_scheduler.scheduler_name }
    assert_redirected_to service_scheduler_path(assigns(:service_scheduler))
  end

  test "should destroy service_scheduler" do
    assert_difference('ServiceScheduler.count', -1) do
      delete :destroy, id: @service_scheduler
    end

    assert_redirected_to service_schedulers_path
  end
end
