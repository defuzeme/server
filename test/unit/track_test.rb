require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  test "create valid track" do
    assert_difference 'Track.count' do
      create_track
    end
  end
  
  test "fetch existing track" do
    t1 = create_track
    t2 = nil
    search = t1.attributes
    search[:year] = 1900
    assert_no_difference 'Track.count' do
      t2 = Track.fetch search
    end
    assert_equal t1, t2
  end
  
  test "fetch new track" do
    t1 = create_track
    t2 = nil
    search = t1.attributes
    search['title'] = 'toto'
    assert_difference 'Track.count' do
      t2 = Track.fetch search
    end
    assert_not_equal t1, t2    
  end

  test "don't create duplicate track" do
    create_track
    assert_no_difference 'Track.count' do
      create_track
    end
    assert_no_difference 'Track.count' do
      create_track :duration => 16
    end
  end

  test "don't create track without name" do
    assert_no_difference 'Track.count' do
      create_track :title => nil
    end
  end

=begin
  test "don't create track with invalid duration" do
    assert_no_difference 'Track.count' do
      create_track :duration => nil
      create_track :duration => -1
    end
  end
=end
  
  test "duplicate track if one parameter different" do
    create_track
    assert_difference 'Track.count' do
      create_track :title => 'toto'
    end
    assert_difference 'Track.count' do
      create_track :album => 'toto'
    end
    assert_difference 'Track.count' do
      create_track :artist => 'toto'
    end
  end
  
protected

  def create_track(options = {})
    t = Track.new({
      :title => 'The good life',
      :artist => 'Bobby Darin',
      :album => 'Matchstick Men',
      :duration => 230.3,
      :year => 1942,
      :genre => 'soundtrack'
    }.merge(options))
    t.save
    t
  end
end
