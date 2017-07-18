require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new blubb" do
    get signup_path
    assert_response :success
  end

end
