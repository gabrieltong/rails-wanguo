require 'test_helper'

class AnnexesControllerTest < ActionController::TestCase
  setup do
    @annex = annexes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:annexes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create annex" do
    assert_difference('Annex.count') do
      post :create, annex: { law_id: @annex.law_id, state: @annex.state, title: @annex.title }
    end

    assert_redirected_to annex_path(assigns(:annex))
  end

  test "should show annex" do
    get :show, id: @annex
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @annex
    assert_response :success
  end

  test "should update annex" do
    put :update, id: @annex, annex: { law_id: @annex.law_id, state: @annex.state, title: @annex.title }
    assert_redirected_to annex_path(assigns(:annex))
  end

  test "should destroy annex" do
    assert_difference('Annex.count', -1) do
      delete :destroy, id: @annex
    end

    assert_redirected_to annexes_path
  end
end
