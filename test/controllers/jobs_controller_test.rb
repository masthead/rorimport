require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get skimming" do
    get :skimming
    assert_response :success
  end

  test "should get launching" do
    get :launching
    assert_response :success
  end

end
