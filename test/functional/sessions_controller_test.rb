require 'test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < ActionController::TestCase
  fixtures :users

  test 'should login and redirect' do
    post :create, :login => 'quentin', :password => 'monkey'
    assert session[:user_id]
    assert_response :redirect
  end

  test 'should fail login and not redirect' do
    post :create, :login => 'quentin', :password => 'bad password'
    assert_nil session[:user_id]
    assert_response :success
  end

  test 'should logout' do
    login_as :quentin
    get :destroy
    assert_nil session[:user_id]
    assert_response :redirect
  end

  test 'should remember me' do
    @request.cookies["auth_token"] = nil
    post :create, :login => 'quentin', :password => 'monkey', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  test 'should not remember me' do
    @request.cookies["auth_token"] = nil
    post :create, :login => 'quentin', :password => 'monkey', :remember_me => "0"
    assert @response.cookies["auth_token"].blank?
  end
  
  test 'should delete token on logout' do
    login_as :quentin
    get :destroy
    assert @response.cookies["auth_token"].blank?
  end

  test 'should login with cookie' do
    users(:quentin).remember_me
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert @controller.send(:logged_in?)
  end

  test 'should fail expired cookie login' do
    users(:quentin).remember_me
    users(:quentin).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert !@controller.send(:logged_in?)
  end

  test 'should fail cookie login' do
    users(:quentin).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    assert !@controller.send(:logged_in?)
  end
  
  test 'should generate token using json api' do
    post :create, :login => 'quentin', :password => 'monkey', :format => :json
    assert_response :success
    t = Token.last
    assert_equal response.json['token'], t.token, "bad token returned"
    assert_not_nil response.json['created_at'], "no creation date"
    assert_not_nil response.json['expires_at'], "no expiration date"
    assert_nil response.json['user_id'], "user_id should not be sent"
    assert_nil response.json['id'], "id should not be sent"
  end

  test 'should generate token using xml api' do
    post :create, :login => 'quentin', :password => 'monkey', :format => :xml
    assert_response :success
    t = Token.last
    assert_equal response.xml['token']['token'], t.token, "bad token returned"
    assert_not_nil response.xml['token']['created_at'], "no creation date"
    assert_not_nil response.xml['token']['expires_at'], "no expiration date"
    assert_nil response.xml['token']['user_id'], "user_id should not be sent"
    assert_nil response.xml['token']['id'], "id should not be sent"
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
end
