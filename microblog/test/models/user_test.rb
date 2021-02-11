require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "          "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "          "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.com a_us-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |email|
      @user.email = email
      assert @user.valid?, "#{email} should be valid."
    end
  end

  test "email validation rejects invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_bar.org
                           user.name@example@bar.com for@bar+baz.com]

    invalid_addresses.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email} should be invalid."
    end
  end
end
