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
    assert_template 'users/new'
  end

  test "valid signup" do
    assert_difference "User.count" do
      post users_path, params: {
             user: {
               name: "Mike",
               email: "mike@example.com",
               password: "password",
               password_confirmation: "password"
             }
           }
    end

    follow_redirect!
    assert_template 'users/show'
    assert_not flash.blank?
  end
end
