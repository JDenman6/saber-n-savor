require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "unsuccessful edit attmept" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        name: "",
        email: "foo@invalid",
        password: "this",
        password_confirmation: "that"
      }
    }
    assert_template 'users/edit'
    assert_select "div.alert", {count: 1, text: "The form contains 4 errors."}
  end

  test "successful edit attempt" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
      user: {
        name:  name,
        email: email,
        password:              "",
        password_confirmation: ""
        }
      }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
