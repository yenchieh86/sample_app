require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @user = users(:yen)
  end
  
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
  
  test "should show correct number for followers and following" do
    @user = users(:kimi)
    log_in_as(@user)
    get root_path
    assert_select "strong#following", text: "0"
    assert_select "strong#followers", text: "0"
    following_user = User.all[6..30]
    followers_user = User.all[6..11]
    
    n = 0
    get root_path
    assert_select "strong#followers", text: "0"
    followers_user.each do |user|
      user.active_relationships.create(followed_id: @user.id)
      n += 1
      get root_path
      assert_select "strong#followers", text: "#{n}"
    end
    
    n = 0
    following_user.each do |user|
      @user.active_relationships.create(followed_id: user.id)
      n += 1
      get root_path
      assert_select "strong#following", text: "#{n}"
    end
  end
  
end
