require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "get public page" do
    get :index
    assert_response :success
  end
  
  test "get logged-in public page" do
    u = users(:aaron)
    login_as u
    get :index
    assert_response :success
  end
  
  test "should allow admin page for admin" do
    u = users(:quentin)
    login_as u
    get :admin
    assert_response :success
  end

  test "should not allow basic user to see admin page" do
    u = users(:aaron)
    login_as u
    get :admin
    assert_response :forbidden
  end

  test "should not allow public to see admin page" do
    get :admin
    assert_response :forbidden
  end
end
