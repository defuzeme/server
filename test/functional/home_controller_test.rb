require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "get public page" do
    get :index
    assert_response :success
  end
  
  test "host should change" do
  	old_host = $host
	  @request.env['HTTP_HOST'] = 'ya.ru'
  	get :index
  	assert_equal 'ya.ru', $host
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
  
  test "should get request hostname stored" do
    get :index
    assert_equal 'test.host', $host
  end
  
  test "logged-in user should access dashboard page" do
    u = users(:quentin)
    login_as u
    get :dashboard
    assert_response :success
  end

  test "public user should not access dashboard page" do
    get :dashboard
    assert_response :unauthorized
  end

  test "valid get api token should access dashboard page" do
    u = users(:quentin)
    t = u.tokens.valid.first
    get :dashboard, :format => :json, :api_token => t.token
    assert_response :success
    assert_not_nil response.json['user']
    assert_equal u.name, response.json['user']['name']
    assert_not_nil response.json['radio']
    assert_equal u.radio.name, response.json['radio']['name']
  end

  test "valid header api token should access dashboard page" do
    u = users(:quentin)
    t = u.tokens.valid.first
    @request.env['HTTP_API_TOKEN'] = t.token
    get :dashboard, :format => :xml
    assert_response :success
    assert_not_nil response.xml['hash']['user']
    assert_equal u.name, response.xml['hash']['user']['name']
    assert_not_nil response.xml['hash']['radio']
    assert_equal u.radio.name, response.xml['hash']['radio']['name']
  end

  test "expired api token should not access dashboard page" do
    u = users(:quentin)
    t = u.tokens.expired.first
    get :dashboard, :format => :json, :api_token => t.token
    assert_response :unauthorized
  end

  test "api login should update last_use_at field" do
    u = users(:quentin)
    t = u.tokens.valid.first
    prev_date = t.last_use_at
    get :dashboard, :format => :json, :api_token => t.token
    assert_response :success
    assert_not_equal t.reload.last_use_at, prev_date
  end
end
