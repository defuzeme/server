require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  def setup
    $host = 'test.defuze.me'
  end

  test 'should_create_user' do
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end
  
  test 'should update invitation at creation' do
    i = invitations :aaron_to_john
    user = create_user
    i.reload
    assert_equal user, i.new_user
    assert_not_nil i.accepted_at
  end

  test 'should get invitation radio' do
    i = invitations :aaron_to_john
    assert_not_nil i.radio
    user = create_user
    assert_equal i.radio, user.radio
  end

  test 'should_initialize_activation_code_upon_creation' do
    user = create_user
    user.reload
    assert_not_nil user.activation_code
  end

  test 'should initialize invitations left upon creation' do
    user = create_user
    user.reload
    assert_equal User::INVITATIONS_PER_USER, user.invitations_left
  end

  test 'should_require_login' do
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors[:login]
    end
  end

  test 'should_require_password' do
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors[:password]
    end
  end

  test 'should_require_password_confirmation' do
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors[:password_confirmation]
    end
  end

  test 'should_require_email' do
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors[:email]
    end
  end

  test 'should_reset_password' do
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  test 'should_not_rehash_password' do
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'monkey')
  end

  test 'should_authenticate_user' do
    assert_equal users(:quentin), User.authenticate('quentin', 'monkey')
  end

  test 'should_set_remember_token' do
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  test 'should_unset_remember_token' do
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  test 'should_remember_me_for_one_week' do
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  test 'should_remember_me_until_one_week' do
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  test 'should_remember_me_default_two_weeks' do
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end
  
  test 'should_not_be_set_admin_by_mass_assignment' do
    users(:aaron).update_attributes :admin => true
    assert !users(:aaron).admin, 'mass assigned admin'
  end

  test 'should_be_set_admin_by_uniq_assignment' do
    users(:aaron).update_attribute :admin, true
    assert users(:aaron).admin, 'not assigned admin'
  end

  protected

  def create_user(options = {})
    i = invitations :aaron_to_john
    record = User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69', :invitation_code => i.token }.merge(options))
    record.save
    record
  end
end
