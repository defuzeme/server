require 'test_helper'
require 'user_mailer'

class UserMailerTest < ActionMailer::TestCase

  def setup
    $host = 'test.defuze.me'
    @user = users(:quentin)
  end


  test "signup_notification" do
    # Send the email, then test that it got queued
    @user.activation_code = '42'*10
    email = UserMailer.signup_notification(@user).deliver
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [@user.email], email.to
    assert_equal "[Defuze.me] Please activate your new account", email.subject
    assert_match /Your account has been created./, email.encoded
    assert_match /http\:\/\/#{$host}\/(fr|en)\/activate\/#{@user.activation_code}/, email.encoded
  end

  test "activation" do
    email = UserMailer.activation(@user).deliver
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [@user.email], email.to
    assert_equal "[Defuze.me] Your account has been activated!", email.subject
    assert_match /http\:\/\/#{$host}\//, email.encoded
  end
end
