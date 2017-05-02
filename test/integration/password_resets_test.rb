require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:one)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    ## test invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    ## test valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    ## in password_reset form
    user = assigns(:user)
    ## test wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    ## test an inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    ## test the combo of right email and wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    ## test the right email with the right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    ## test with a confirmation that doesn't match the new password
    patch password_reset_path(user.reset_token), params: {
        email: user.email,
         user: {
           password:            "fruitsie",
           password_confirmation: "troutsie"
         }
    }
    assert_select 'div#error_explanation'
    # test an empty password
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
       user: {
         password: "",
         password_confirmation: ""
       }
    }
    assert_select 'div#error_explanation'
    # test valid password with matching confirmation
    patch password_reset_path(user.reset_token), params: {
        email: user.email,
         user: {
           password:            "fruitsie",
           password_confirmation: "fruitsie"
         }
    }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
