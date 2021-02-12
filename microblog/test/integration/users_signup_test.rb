require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    assert_no_difference 'User.count' do
      post users_path, params: {
             user: {
               name: "",
               email: "invalid@invalid",
               password: "bar",
               password_confirmation: "foo"
             }
           }
    end
  end
end
