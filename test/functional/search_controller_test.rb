require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get name" do
    get :name
    assert_response :success
  end

  test "should get sku" do
    get :sku
    assert_response :success
  end

  test "should get ingredient" do
    get :ingredient
    assert_response :success
  end

end
