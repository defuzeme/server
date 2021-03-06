require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  test "admin should access" do
    u = users(:quentin)
    assert u.admin?, "#{u.login} is not admin"
    login_as u
    get :index
    assert_response :success
    get :show, :id => 'quentin'
    assert_response :success
    get :edit, :id => 'quentin'
    assert_response :success
    put :update, :id => 'quentin'
    assert_response :redirect
    put :destroy, :id => 'quentin'
    assert_response :redirect
  end
  
  test "require login" do
    get :index
    assert_response :forbidden  
  end

  test "basic user should not access" do
    u = users(:aaron)
    assert (not u.admin?), "#{u.login} is admin"
    login_as u
    get :index
    assert_response :forbidden
    get :show, :id => 'quentin'
    assert_response :forbidden
    get :edit, :id => 'quentin'
    assert_response :forbidden
    put :update, :id => 'quentin'
    assert_response :forbidden
    put :destroy, :id => 'quentin'
    assert_response :forbidden
  end
end
