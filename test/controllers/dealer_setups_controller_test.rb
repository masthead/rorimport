require 'test_helper'

class DealerSetupsControllerTest < ActionController::TestCase
  setup do
    @dealer_setup = dealer_setups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dealer_setups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dealer_setup" do
    assert_difference('DealerSetup.count') do
      post :create, dealer_setup: { completed: @dealer_setup.completed, completed_at: @dealer_setup.completed_at, dealer_id: @dealer_setup.dealer_id, notes: @dealer_setup.notes, priority: @dealer_setup.priority, setup_task_id: @dealer_setup.setup_task_id, user_id: @dealer_setup.user_id }
    end

    assert_redirected_to dealer_setup_path(assigns(:dealer_setup))
  end

  test "should show dealer_setup" do
    get :show, id: @dealer_setup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dealer_setup
    assert_response :success
  end

  test "should update dealer_setup" do
    patch :update, id: @dealer_setup, dealer_setup: { completed: @dealer_setup.completed, completed_at: @dealer_setup.completed_at, dealer_id: @dealer_setup.dealer_id, notes: @dealer_setup.notes, priority: @dealer_setup.priority, setup_task_id: @dealer_setup.setup_task_id, user_id: @dealer_setup.user_id }
    assert_redirected_to dealer_setup_path(assigns(:dealer_setup))
  end

  test "should destroy dealer_setup" do
    assert_difference('DealerSetup.count', -1) do
      delete :destroy, id: @dealer_setup
    end

    assert_redirected_to dealer_setups_path
  end
end
