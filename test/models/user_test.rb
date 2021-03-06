require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Strong Sad", email: "StrongSad@example.com",
                     password: "password", password_confirmation: "password")
  end

  test  "should be valid" do
    assert @user.valid?
  end

  test "name should be non-blank" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "my user name is way way way way way way way too long"
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 8
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "user.authentic? should return false if remember_digest.nil?" do
    assert_not @user.authentic?('')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "folowing and unfollowing" do
    smushy = users(:one)
    lucy   = users(:two)
    assert_not (smushy.following?(lucy) || lucy.following?(smushy) )
    smushy.follow(lucy)
    assert     (smushy.following?(lucy) && !lucy.following?(smushy) )
    assert     lucy.followers.include?(smushy)
    assert_not smushy.followers.include?(lucy)
    smushy.unfollow(lucy)
    assert_not (smushy.following?(lucy) || lucy.following?(smushy) )
  end

  test "feed should have the right posts" do
    smush   = users(:one)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert smush.feed.include?(post_following)
    end
    # Posts from self
    smush.microposts.each do |post_self|
      assert smush.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not smush.feed.include?(post_unfollowed)
    end
  end
end
