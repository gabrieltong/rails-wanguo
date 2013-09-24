require 'test_helper'

class HeartbeatsControllerTest < ActionController::TestCase
  setup do
    @heartbeat = heartbeats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:heartbeats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create heartbeat" do
    assert_difference('Heartbeat.count') do
      post :create, heartbeat: { user_id: @heartbeat.user_id }
    end

    assert_redirected_to heartbeat_path(assigns(:heartbeat))
  end

  test "should show heartbeat" do
    get :show, id: @heartbeat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @heartbeat
    assert_response :success
  end

  test "should update heartbeat" do
    put :update, id: @heartbeat, heartbeat: { user_id: @heartbeat.user_id }
    assert_redirected_to heartbeat_path(assigns(:heartbeat))
  end

  test "should destroy heartbeat" do
    assert_difference('Heartbeat.count', -1) do
      delete :destroy, id: @heartbeat
    end

    assert_redirected_to heartbeats_path
  end
end
