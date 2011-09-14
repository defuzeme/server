require 'test_helper'

class QueueElemsControllerTest < ActionController::TestCase
  QUEUE_ELEM = { :position => 1,
        :play_at => Time.now,
        :kind => 'QueueTrack',
        :track_attributes => {
          :name => 'Long Train Runnin\'',
          :artist => 'Doobie Brothers',
          :album => 'The very best of'}}


  test "add element to queue" do
    queue_elem = { :position => 1,
        :play_at => Time.now,
        :kind => 'QueueTrack',
        :track_attributes => {
          :name => 'Long Train Runnin\'',
          :artist => 'Doobie Brothers',
          :album => 'The very best of'}}
    u = users :quentin
    login_as u
    assert_difference 'u.radio.queue_elems.count', 1 do
      post :create, :radio_id => u.radio.to_param, :queue_elem => queue_elem, :format => :json
      assert_response :created
    end
  end
  
  test "delete element from queue" do
    create_queue_elem
    u = users :quentin
    login_as u
    assert_difference 'u.radio.queue_elems.count', -1 do
      delete :destroy, :radio_id => u.radio.to_param, :id => 1
    end
  end
  
  test "insert element to queue" do
    elem = create_queue_elem
    assert_equal 1, elem.position, "First elem bad initialization"
    queue_elem = QUEUE_ELEM
    u = users :quentin
    login_as u
    assert_difference 'u.radio.queue_elems.count', 1 do
      post :create, :radio_id => u.radio.to_param, :queue_elem => queue_elem
    end
    elem.reload
    assert_equal 2, elem.position, "Existing not shifted"
  end

  protected

  def create_queue_elem(options = {})
    t = QueueElem.new({
      :radio => radios(:rfm),
      :track => tracks(:train),
    }.merge(options))
    t.save
    t
  end
end
