require 'test_helper'

class PendingCandiesControllerTest < ActionController::TestCase
  setup do
    @pending_candy = pending_candies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pending_candies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pending_candy" do
    assert_difference('PendingCandy.count') do
      post :create, :pending_candy => @pending_candy.attributes
    end

    assert_redirected_to pending_candy_path(assigns(:pending_candy))
  end

  test "should show pending_candy" do
    get :show, :id => @pending_candy.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @pending_candy.to_param
    assert_response :success
  end

  test "should update pending_candy" do
    put :update, :id => @pending_candy.to_param, :pending_candy => @pending_candy.attributes
    assert_redirected_to pending_candy_path(assigns(:pending_candy))
  end

  test "should destroy pending_candy" do
    assert_difference('PendingCandy.count', -1) do
      delete :destroy, :id => @pending_candy.to_param
    end

    assert_redirected_to pending_candies_path
  end
end
