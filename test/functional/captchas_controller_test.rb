require 'test_helper'

class CaptchasControllerTest < ActionController::TestCase
  test "should get valid" do
    get :valid
    assert_response :success
  end

  test "should get expired" do
    get :expired
    assert_response :success
  end

  test "should get unused" do
    get :unused
    assert_response :success
  end

end
