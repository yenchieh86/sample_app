require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:yen)
    @other_user = users(:jack)
    @unactivated_user = users(:lana)
  end
  
  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select "div.pagination", count: 2
    User.where(activated: true).paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end
  
  test "index as admin includeing pagination and delete links" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user = @user
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
  end
  
  test "index as non-admin" do
    log_in_as(@other_user)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
  
  test "index should not show unactivated user" do
    log_in_as(@other_user)
    get users_path
    assert_select 'a', text: @unactivated_user.name, count: 0
  end
  
  test "should refirect to root page for unactivated user show page" do
    log_in_as(@other_user)
    get user_path(@unactivated_user)
    assert_redirected_to root_url
  end
end
