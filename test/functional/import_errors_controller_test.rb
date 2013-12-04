require 'test_helper'

class ImportErrorsControllerTest < ActionController::TestCase
  setup do
    @import_error = import_errors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:import_errors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create import_error" do
    assert_difference('ImportError.count') do
      post :create, import_error: { import_id: @import_error.import_id, title: @import_error.title }
    end

    assert_redirected_to import_error_path(assigns(:import_error))
  end

  test "should show import_error" do
    get :show, id: @import_error
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @import_error
    assert_response :success
  end

  test "should update import_error" do
    put :update, id: @import_error, import_error: { import_id: @import_error.import_id, title: @import_error.title }
    assert_redirected_to import_error_path(assigns(:import_error))
  end

  test "should destroy import_error" do
    assert_difference('ImportError.count', -1) do
      delete :destroy, id: @import_error
    end

    assert_redirected_to import_errors_path
  end
end
