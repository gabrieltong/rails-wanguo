require 'test_helper'

class PhonesignControllerTest < ActionController::TestCase
  test "should get generate" do
    get :generate
    assert_response :success
  end

  test "should get validate" do
    get :validate
    assert_response :success
  end

end
