require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
  test "anybody can view error page" do
    get :show, :id => hex_code
    assert_response :success
  end
  
  test "guest can't edit error" do
    get :edit, :id => hex_code
    assert_response :unauthorized
  end
  
  test "guest can't update error" do
    put :update, :id => hex_code, :error => {:msg => 'toto'}
    assert_response :unauthorized
    assert_not_equal 'toto', error.msg
  end

  test "user can't edit error" do
    u = users :aaron
    login_as u
    get :edit, :id => hex_code
    assert_response :forbidden
  end
  
  test "user can't update error" do
    u = users :aaron
    login_as u
    put :update, :id => hex_code, :error => {:msg => 'toto'}
    assert_response :forbidden
    assert_not_equal 'toto', error.msg
  end

  test "admin can edit error" do
    u = users :quentin
    login_as u
    get :edit, :id => hex_code
    assert_response :success
  end

  test "admin can update error" do
    u = users :quentin
    login_as u
    put :update, :id => hex_code, :error => {:msg => 'toto'}
    assert_response :redirect
    assert_equal 'toto', error.msg
  end
  
protected

  def error
    Error.first
  end

  def hex_code
    error.hex_code
  end
end
