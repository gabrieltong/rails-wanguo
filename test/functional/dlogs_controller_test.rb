require 'test_helper'

class DlogsControllerTest < ActionController::TestCase
  setup do
    @dlog = dlogs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dlogs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dlog" do
    assert_difference('Dlog.count') do
      post :create, dlog: { content: @dlog.content, method: @dlog.method, params: @dlog.params, user_id: @dlog.user_id }
    end

    assert_redirected_to dlog_path(assigns(:dlog))
  end

  test "should show dlog" do
    get :show, id: @dlog
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dlog
    assert_response :success
  end

  test "should update dlog" do
    put :update, id: @dlog, dlog: { content: @dlog.content, method: @dlog.method, params: @dlog.params, user_id: @dlog.user_id }
    assert_redirected_to dlog_path(assigns(:dlog))
  end

  test "should destroy dlog" do
    assert_difference('Dlog.count', -1) do
      delete :destroy, id: @dlog
    end

    assert_redirected_to dlogs_path
  end
end
