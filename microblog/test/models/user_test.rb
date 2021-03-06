require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
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
                           user.name@example@bar.com for@bar+baz.com
                           foo@bar..com]

    invalid_addresses.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email} should be invalid."
    end
  end

  test "emails should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "emails should be downcased" do
    mixed_case_email = "MaMa@ExMPle.ORg"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should be 6 chars" do
    @user.password = @user.password_confirmation = " " * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with a nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "deleting user should delete associated microposts" do
    @user.save
    @user.microposts.create!(content: "blah blah blah")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    assert_no_difference 'User.count' do
      michael.unfollow(archer)
    end
    assert_not michael.following?(archer)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)

    # Posts from followed user
    michael.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end

    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end

    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
