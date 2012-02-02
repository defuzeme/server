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
  
  test "guest can report error" do
    assert_difference 'error.instances.count', 1 do
      get :show, :id => hex_code, :report => 'init'
      assert_response :redirect
    end
  end

  test "user can report error" do
    u = users :aaron
    login_as u
    assert_difference 'error.instances.count', 1 do
      get :show, :id => hex_code, :report => 'init'
      assert_response :redirect
    end
    assert_equal u, error.instances.last.user
  end
  
  test "user can't report twice error" do
    u = users :aaron
    login_as u
    instance = error_instances :aaron
    puts instance.inspect
    assert_difference 'instance.count', 1 do
      assert_no_difference 'error.instances.count' do
        get :show, :id => hex_code, :report => 'run'
        assert_response :redirect
      end
      instance.reload
    end
  end
  
  test "simple view does not report" do
    assert_no_difference 'error.instances.count' do
      get :show, :id => hex_code
      assert_response :success
    end    
  end
  
protected

  def error
    Error.first
  end

  def hex_code
    error.hex_code
  end
end
