require 'test_helper'

def setup

end

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "SaberNSavor"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | SaberNSavor"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | SaberNSavor"
  end

end
