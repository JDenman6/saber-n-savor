require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "unsuccessful edit attmept" do
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
end
