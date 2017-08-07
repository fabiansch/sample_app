require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:bob)
  end

  test "layout links with user that is not logged in" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", "http://news.railstutorial.org/"
    assert_select "a[href=?]", users_path,            count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0
    assert_select "a[href=?]", user_path(@user),      count: 0
    assert_select "a[href=?]", logout_path,           count: 0
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign Up")
    get login_path
    assert_select "title", full_title("Log in")
    log_in_as(@user)
    get edit_user_path @user
  end

    test "layout links with user that is logged in" do
    log_in_as @user
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", "http://news.railstutorial.org/"
    assert_select "a[href=?]", users_path,            count: 1
    assert_select "a[href=?]", edit_user_path(@user), count: 1
    assert_select "ul.dropdown-menu>li>a[href=?]", user_path(@user),      count: 1
    assert_select "a[href=?]", logout_path,           count: 1
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign Up")
    get login_path
    assert_select "title", full_title("Log in")
    log_in_as(@user)
    get edit_user_path @user
    assert_select "title", full_title("Edit #{@user.name}")
  end

  test "titels with user that is not logged in" do
    get root_path
    assert_select "title", full_title
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign Up")
    get login_path
    assert_select "title", full_title("Log in")

    get edit_user_path @user
    follow_redirect!
    assert_select "title", full_title("Log in")
  end

  test "titels with user that is logged in" do
    log_in_as @user
    get edit_user_path @user
    assert_select "title", full_title("Edit #{@user.name}")
    get user_path @user
    assert_select "title", full_title(@user.name)
    get users_path
    assert_select "title", full_title("All users")

  end


end
