require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "user should invite" do
    u = users :quentin
    assert_difference 'Invitation.count' do
      create_invitation :creator => u
    end
  end

  test "should generate token" do
    u = users :quentin
    i = create_invitation :creator => u
    assert_match /[a-z][0-9]+/i, i.token, "Bad token"
  end

  test "can't invite same person twice" do
    u = users :quentin
    assert_no_difference 'Invitation.count' do
      i = create_invitation :creator => u, :email => 'john@yopmail.com'
      assert i.errors[:email].any?
    end
  end

  test "can't invite registered users" do
    u = users :quentin
    assert_no_difference 'Invitation.count' do
      i = create_invitation :creator => u, :email => u.email
      assert i.errors[:email].any?
    end
  end

  test "can't invite without creator" do
    assert_no_difference 'Invitation.count' do
      create_invitation
    end
  end
  
  test "auto set activated when new_user is set" do
    i = invitations :aaron_to_john
    u2 = users :john
    assert_nil i.accepted_at
    i.update_attribute :new_user, u2
    assert_not_nil i.accepted_at, 'accepted_at not set'
  end
  
  test "should send email" do
    i = invitations :aaron_to_john
    assert_nil i.sent_at
    i.send!
    assert_not_nil i.sent_at, "email not sent"
  end

  protected

  def create_invitation(options = {})
    Invitation.create({ :email => 'bob2@yopmail.com' }.merge(options))
  end
end
