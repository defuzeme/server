require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test 'should invite' do
    u = users :aaron
    login_as u
    assert_difference 'Invitation.count' do
      get :new
      assert_response :success
      invite
      assert_response :redirect
    end
  end

  test 'should invite with message' do
    u = users :aaron
    login_as u
    assert_difference 'Invitation.count' do
      get :new
      assert_response :success
      invite(:message => "Hello you !")
      assert_response :redirect
    end
  end

  test 'should not redirect on errors' do
    u = users :aaron
    login_as u
    assert_no_difference 'Invitation.count' do
      get :new
      assert_response :success
      invite(:email => '')
      assert_response :success
    end
  end

  test 'should reject if not login' do
    get :new
    assert_response :unauthorized
    assert_no_difference 'Invitation.count' do
      invite
      assert_response :unauthorized
    end
  end

  test 'should reject if not more invitations' do
    u = users :quentin
    u.update_attribute :invitations_left, 0
    login_as u
    get :new
    assert_response :forbidden
    assert_no_difference 'Invitation.count' do
      invite
      assert_response :forbidden
    end
  end
  
  test 'show should open invitation' do
    i = invitations :aaron_to_john
    assert_nil i.opened_at
    get :show, :id => i.token
    i.reload
    assert_not_nil i.opened_at
  end

  test 'show should not open invitation if connected' do
    i = invitations :aaron_to_john
    u = i.creator
    login_as u
    assert_nil i.opened_at
    get :show, :id => i.token
    i.reload
    assert_nil i.opened_at
  end
  
  protected

  def invite(options = {})
    post :create, :invitation => { :email => 'bonjour@yopmail.com' }.merge(options)
  end
end
