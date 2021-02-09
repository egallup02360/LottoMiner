require 'test_helper'

class PoolsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pools_index_url
    assert_response :success
  end

  test "should get create" do
    get pools_create_url
    assert_response :success
  end

  test "should get update" do
    get pools_update_url
    assert_response :success
  end

  test "should get destroy" do
    get pools_destroy_url
    assert_response :success
  end

end
