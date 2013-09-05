require 'test_helper'

class FreelawsControllerTest < ActionController::TestCase
  setup do
    @freelaw = freelaws(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:freelaws)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create freelaw" do
    assert_difference('Freelaw.count') do
      post :create, freelaw: { ancestry: @freelaw.ancestry, content: @freelaw.content, title: @freelaw.title }
    end

    assert_redirected_to freelaw_path(assigns(:freelaw))
  end

  test "should show freelaw" do
    get :show, id: @freelaw
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @freelaw
    assert_response :success
  end

  test "should update freelaw" do
    put :update, id: @freelaw, freelaw: { ancestry: @freelaw.ancestry, content: @freelaw.content, title: @freelaw.title }
    assert_redirected_to freelaw_path(assigns(:freelaw))
  end

  test "should destroy freelaw" do
    assert_difference('Freelaw.count', -1) do
      delete :destroy, id: @freelaw
    end

    assert_redirected_to freelaws_path
  end
end
