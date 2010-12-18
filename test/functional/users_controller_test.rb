require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase
  fixtures :users

  test 'should allow signup' do
    assert_difference 'User.count' do
      create_user
      assert_response :redirect
    end
  end

  test 'should require login on signup' do
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors[:login]
      assert_response :success
    end
  end

  test 'should require password on signup' do
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors[:password]
      assert_response :success
    end
  end

  test 'should require password confirmation on signup' do
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors[:password_confirmation]
      assert_response :success
    end
  end

  test 'should require email on signup' do
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert assigns(:user).errors[:email]
      assert_response :success
    end
  end
  
  test 'should sign up user with activation code' do
    create_user
    assigns(:user).reload
  #  activation disabled during invitation beta
  #  assert_not_nil assigns(:user).activation_code
  end

  test 'should activate user' do
    assert_nil User.authenticate('aaron', 'test')
    get :activate, :activation_code => users(:aaron).activation_code
    assert_redirected_to '/login'
    assert_not_nil flash[:notice]
    assert_equal users(:aaron), User.authenticate('aaron', 'monkey')
  end
  
  test 'should not activate user without key' do
    begin
      get :activate
      assert_nil flash[:notice]
    rescue ActionController::RoutingError
      # in the event your routes deny this, we'll just bow out gracefully.
    end
  end

  test 'should not activate user with blank key' do
    begin
      get :activate, :activation_code => ''
      assert_nil flash[:notice]
    rescue ActionController::RoutingError
      # well played, sir
    end
  end
  
  test 'should not be set admin by mass assignment' do
    assert_difference 'User.count' do
      create_user(:admin => true)
      assert assigns(:user).admin == false
    end
  end
  
  test 'not logged user should not be able to edit' do
    u = users(:aaron)
    old = u.email
    get :edit, :id => u.login
    assert_response :unauthorized
    put :update, :id => u.login, :user => {:email => 'me@aaron.com'}
    assert_response :unauthorized
    u.reload
    assert_equal old, u.email
  end

  test 'logged user should be able to edit other user' do
    u = users(:aaron)
    login_as u
    old = u.email
    get :edit, :id => 'quentin'
    assert_response :forbidden
    put :update, :id => 'quentin', :user => {:email => 'me@aaron.com'}
    assert_response :forbidden
    u.reload
    assert_equal old, u.email
  end

  test 'logged user should be able to edit' do
    u = users(:aaron)
    login_as u
    get :edit, :id => u.login
    assert_response :success
    put :update, :id => u.login, :user => {:email => 'me@aaron.com'}
    assert_response :redirect
    u.reload
    assert_equal 'me@aaron.com', u.email
  end
  
  protected

  def create_user(options = {})
    i = invitations :aaron_to_john
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69', :invitation_code => i.token}.merge(options)
  end
end
