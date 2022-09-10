require 'test_helper'

class ApprovalsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get approvals_create_url
    assert_response :success
  end

  test "should get edit" do
    get approvals_edit_url
    assert_response :success
  end

  test "should get update" do
    get approvals_update_url
    assert_response :success
  end

end
