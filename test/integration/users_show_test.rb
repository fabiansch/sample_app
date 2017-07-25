require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users :bob
    @admin      = users :bob
    @non_admin  = users :ana
    @activated      = users(:bob)
    @non_activated  = users(:non_activated)
  end

  test "show of non_activated user gets redirected" do
    log_in_as @user
    get user_path @non_activated
    assert_redirected_to root_url
  end

  test "show of activated user gets rendered" do
    log_in_as @user
    get user_path @activated
    assert_template 'users/show'
  end

end
