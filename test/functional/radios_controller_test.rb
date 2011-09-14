require 'test_helper'

class RadiosControllerTest < ActionController::TestCase
  test 'should allow create' do
    u = users :aaron
    login_as u
    assert_difference 'Radio.count' do
      get :new
      assert_response :success
      create_radio
      assert_response :redirect
    end
  end

  test 'everyone should view' do
    r = radios :rfm
    get :show, :id => r.to_param
    assert_response :success
  end

  test 'admin should get' do
    u = users :quentin
    login_as u
    get :edit, :id => u.radio.to_param
    assert_response :success
    get :delete, :id => u.radio.to_param
    assert_response :success
  end

  test 'admin should update' do
    u = users :quentin
    login_as u
    put :update, :id => u.radio.to_param, :radio => {:name => 'RTL2'}
    assert_response :redirect
    assert Radio.find_by_name('RTL2'), 'name did not changed';
  end

  test 'admin should destroy' do
    u = users :quentin
    login_as u
    assert_difference 'Radio.count', -1, 'radio no deleted' do
      delete :destroy, :id => u.radio.to_param
      assert_response :redirect
    end
  end

  test 'should reject if not login' do
    u = users :quentin
    get :new
    assert_response :unauthorized
    get :edit, :id => u.radio.to_param
    assert_response :unauthorized
    get :delete, :id => u.radio.to_param
    assert_response :unauthorized
    put :update, :id => u.radio.to_param, :radio => {:name => 'RTL2'}
    assert_response :unauthorized
    assert_no_difference 'Radio.count' do
      delete :destroy, :id => u.radio.to_param
      assert_response :unauthorized
    end
    assert_no_difference 'Radio.count' do
      create_radio
      assert_response :unauthorized
    end
  end

  test 'should reject if bad user' do
    u = users :quentin
    login_as users(:aaron)
    get :edit, :id => u.radio.to_param
    assert_response :forbidden
    get :delete, :id => u.radio.to_param
    assert_response :forbidden
    put :update, :id => u.radio.to_param, :radio => {:name => 'RTL2'}
    assert_response :forbidden
    assert_no_difference 'Radio.count' do
      delete :destroy, :id => u.radio.to_param
      assert_response :forbidden
    end
  end

  test 'should not create if already existing' do
    u = users :quentin
    login_as u
    assert_no_difference 'Radio.count' do
      get :new
      assert_response :forbidden
      create_radio
      assert_response :forbidden
    end
  end
  
  test 'should update play queue' do
    queue_elems = [
      { :position => 1,
        :play_at => Time.now,
        :kind => 'QueueTrack',
        :track_attributes => {
          :title => 'Test song',
          :artist => 'Test artist',
          :year => 2042,
          :duration => 13}},
      { :position => 2,
        :play_at => 3.minutes.from_now,
        :kind => 'QueueTrack',
        :track_attributes => {
          :title => 'Last Friday Night',
          :artist => 'Katy Perry',
          :duration => 250}}]
    u = users :quentin
    login_as u
    assert_difference 'Track.count', 2 do
      put :update, :id => u.radio.to_param, :radio => {:queue_elems_attributes => queue_elems}, :format => :json
      assert_response :success
      assert u.radio.queue_elems.count >= 2, 'no queue elems created';
      assert_equal 2, u.radio.queue_elems.count, 'initial element not destroyed';
    end
  end
  
  test 'global queue update should empty the queue' do
    u = users :quentin
    login_as u
    create_queue_elem
    assert_difference 'u.radio.queue_elems.count', -1 do
      put :update, :id => u.radio.to_param, :radio => {:queue_elems_attributes => []}, :format => :json
      assert_response :success
    end
  end
  
  test 'queue update do not duplicate track' do
    queue_elems = [
      { :position => 1,
        :play_at => Time.now,
        :kind => 'QueueTrack',
        :track_attributes => {
          :title => 'Long Train Runnin\'',
          :artist => 'Doobie Brothers',
          :album => 'The very best of'}}]
    u = users :quentin
    login_as u
    create_queue_elem
    assert_no_difference 'Track.count' do
      put :update, :id => u.radio.to_param, :radio => {:queue_elems_attributes => queue_elems}, :format => :json
      assert_response :success
    end
  end

  protected

  def create_radio(options = {})
    post :create, :radio => { :name => 'Rire & Chansons', :frequency => 98.2 }.merge(options)
  end
  
  def create_queue_elem(options = {})
    t = QueueElem.new({
      :radio => radios(:rfm),
      :track => tracks(:train),
    }.merge(options))
    t.save
    t
  end
end
