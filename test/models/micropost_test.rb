require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users :one
    @micropost = Micropost.new(content: "lorem ipsum", user_id: @user.id)
  end

  test "post should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
end
