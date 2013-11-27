require 'test_helper'

class CaptchasControllerTest < ActionController::TestCase
  setup do
    @captcha = captchas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:captchas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create captcha" do
    assert_difference('Captcha.count') do
      post :create, captcha: { title: @captcha.title, used_at: @captcha.used_at, user_id: @captcha.user_id }
    end

    assert_redirected_to captcha_path(assigns(:captcha))
  end

  test "should show captcha" do
    get :show, id: @captcha
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @captcha
    assert_response :success
  end

  test "should update captcha" do
    put :update, id: @captcha, captcha: { title: @captcha.title, used_at: @captcha.used_at, user_id: @captcha.user_id }
    assert_redirected_to captcha_path(assigns(:captcha))
  end

  test "should destroy captcha" do
    assert_difference('Captcha.count', -1) do
      delete :destroy, id: @captcha
    end

    assert_redirected_to captchas_path
  end
end
