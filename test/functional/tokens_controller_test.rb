require 'test_helper'

class TokensControllerTest < ActionController::TestCase
  test "user can show his tokens" do
    tok = Token.first
    user = tok.user
    login_as user
    get :show, :id => tok.to_param, :user_id => user
    assert_response :success
  end

  test "user can't show other's tokens" do
    tok = Token.first
    user = User.where('id != ?', tok.user_id).first
    login_as user
    get :show, :id => tok.to_param, :user_id => tok.user
    assert_response :forbidden
  end

  test "public can't show tokens" do
    tok = Token.first
    user = tok.user
    get :show, :id => tok.to_param, :user_id => user
    assert_response :unauthorized
  end

  test "user can expire his tokens" do
    tok = Token.first
    user = tok.user
    login_as user
    date = tok.expires_at
    put :expire, :id => tok.to_param, :user_id => user
    assert_response :redirect
    tok.reload
    assert_not_equal date, tok.expires_at, 'expiration date not changed'
    assert tok.expires_at <= Time.now, "expiration date still in future"
  end

  test "user can't expire other's tokens" do
    tok = Token.first
    user = User.where('id != ?', tok.user_id).first
    login_as user
    assert_no_difference 'tok.expires_at' do
      put :expire, :id => tok.to_param, :user_id => tok.user
      assert_response :forbidden
      tok.reload
    end
  end

  test "public can't expire tokens" do
    tok = Token.first
    assert_no_difference 'tok.expires_at' do
      put :expire, :id => tok.to_param, :user_id => tok.user
      assert_response :unauthorized
      tok.reload
    end
  end
end
