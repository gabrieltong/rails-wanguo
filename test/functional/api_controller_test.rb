require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get law" do
    get :law
    assert_response :success
  end

  test "should get freelaw" do
    get :freelaw
    assert_response :success
  end

end
