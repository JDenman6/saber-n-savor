require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Strong Sad", email: "StrongSad@example.com")
  end

  test  "should be valid" do
    assert @user.valid?
  end

  test "name should be non-blank" do
    @user.name = "  "
    assert_not @user.valid?
  end
end
