require 'test_helper'

class QueueElemTest < ActiveSupport::TestCase
  test "create valid elem" do
    assert_difference 'QueueElem.count' do
      e = create_queue_elem
    end
  end

  test "auto set position" do
    e = create_queue_elem
    assert_equal 1, e.position
  end

  test "can insert same track twice" do
    assert_difference 'QueueElem.count', 5 do
      5.times do |i|
        e = create_queue_elem
        assert_equal (i+1), e.position
      end
    end
  end

  test "pop first track shift positions" do
    first, second, third = create_many_elems 3
    first.pop!
    assert_nil first.position
    assert_not_nil first.play_at
    assert_equal 1, second.reload.position
    assert_equal 2, third.reload.position
  end
  
  test "fetch radio's current track" do
    current = create_queue_elem
    after = create_queue_elem
    before = create_queue_elem(:play_at => 5.minutes.ago)
    radio = current.radio
    assert_equal current, radio.queue_elems.current
  end
  
  test "remove element shift positions" do
    first, second, third = create_many_elems 3
    second.destroy
    assert_equal 1, first.reload.position
    assert_equal 2, third.reload.position
  end

  test "move element" do
    first, second, third, fourth = create_many_elems 4
    first.insert_at 3
    assert_equal 1, second.reload.position
    assert_equal 2, third.reload.position
    assert_equal 3, first.reload.position
    assert_equal 4, fourth.reload.position
  end
 
protected
  def create_many_elems n = 1, options = {}
    return *((1..n).to_a.map {create_queue_elem(options)})
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
