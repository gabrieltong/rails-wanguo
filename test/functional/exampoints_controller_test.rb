require 'test_helper'

class ExampointsControllerTest < ActionController::TestCase
  setup do
    @exampoint = exampoints(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exampoints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exampoint" do
    assert_difference('Exampoint.count') do
      post :create, exampoint: { title: @exampoint.title }
    end

    assert_redirected_to exampoint_path(assigns(:exampoint))
  end

  test "should show exampoint" do
    get :show, id: @exampoint
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exampoint
    assert_response :success
  end

  test "should update exampoint" do
    put :update, id: @exampoint, exampoint: { title: @exampoint.title }
    assert_redirected_to exampoint_path(assigns(:exampoint))
  end

  test "should destroy exampoint" do
    assert_difference('Exampoint.count', -1) do
      delete :destroy, id: @exampoint
    end

    assert_redirected_to exampoints_path
  end
end
