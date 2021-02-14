require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @not_activated = users(:malory)
  end

  test "Cannot access profile of a none activated user" do
    get users_path(@not_activated)
    assert_redirected_to login_url
  end
end
