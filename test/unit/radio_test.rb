require 'test_helper'

class RadioTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should create radio" do
    assert_difference 'Radio.count' do
      radio = create_radio
      assert !radio.new_record?, "#{radio.errors.full_messages.to_sentence}"
    end
  end

  test "should allow description" do
    assert_difference 'Radio.count' do
      radio = create_radio(:description => 'lorem ipsum')
      assert !radio.new_record?, "#{radio.errors.full_messages.to_sentence}"
      radio.reload
      assert_equal 'lorem ipsum', radio.description
    end
  end

  test "should allow website" do
    for website in ['http://www.google.fr', 'http://www.funradio.fr/', 'http://defuze.me']
      assert_difference 'Radio.count' do
        # different permalink is needed for uniqueness
        radio = create_radio(:website => website, :permalink => "radio_#{website.hash}")
        assert !radio.new_record?, "#{radio.errors.full_messages.to_sentence}"
        radio.reload
        assert_equal website, radio.website
      end
    end
  end

  test "should allow frequency" do
    for freq in ['98.2', '107.65', '88']
      assert_difference 'Radio.count' do
        # different permalink is needed for uniqueness
        radio = create_radio(:frequency => freq, :permalink => "radio_#{freq.hash}")
        assert !radio.new_record?, "#{radio.errors.full_messages.to_sentence}"
        radio.reload
        assert_equal freq.to_f, radio.frequency
      end
    end
  end
   
  test "should allow band" do
    assert_difference 'Radio.count' do
      radio = create_radio(:band => 1)
      assert !radio.new_record?, "#{radio.errors.full_messages.to_sentence}"
      radio.reload
      assert_equal 1, radio.band
    end
  end

  test "should allow band from key" do
    assert_difference 'Radio.count' do
      radio = create_radio(:band_key => :fm)
      assert !radio.new_record?, "#{radio.errors.full_messages.to_sentence}"
      radio.reload
      assert_equal :fm, radio.band_key
    end
  end

  test "should allow band from string key" do
    assert_difference 'Radio.count' do
      radio = create_radio(:band_key => 'fm')
      assert !radio.new_record?, "#{radio.errors.full_messages.to_sentence}"
      radio.reload
      assert_equal :fm, radio.band_key
    end
  end

  test "should ignore invalid band" do
    assert_difference 'Radio.count', 3 do
      for band in [2, :toto, 'lw']
        radio = create_radio(:band_key => band, :permalink => "radio_#{band.hash}")
        assert radio.errors[:band].empty?
      end
    end
  end

  test "should reject invalid frequency" do
    assert_no_difference 'Radio.count' do
      for freq in ['1', 'http', '200']
        radio = create_radio(:frequency => freq, :permalink => "radio_#{freq.hash}")
        assert radio.errors[:frequency].any?
      end
    end
  end

  test "should reject invalid website" do
    assert_no_difference 'Radio.count' do
      for website in ['a', 'http://', 'www.funradio.fr']
        radio = create_radio(:website => website, :permalink => "radio_#{website.hash}")
        assert radio.errors[:website].any?
      end
    end
  end

  test "should reject invalid permalink" do
    assert_no_difference 'Radio.count' do
      for permalink in [nil, 'a', 'fun radio']
        radio = create_radio(:permalink => permalink)
        assert radio.errors[:permalink].any?
      end
    end
  end

  test "should reject invalid name" do
    assert_no_difference 'Radio.count' do
      for name in [nil, 'a', 'my bad\\ name']
        radio = create_radio(:name => name)
        assert radio.errors[:name].any?
      end
    end
  end
  
  test "should get localized enum select" do
    I18n.locale = :en
    assert_equal ['FM', 'AM'], Radio.bands
    assert_equal [['FM', 0], ['AM', 1]], Radio.bands.to_select
  end
 
  protected

  def create_radio(options = {})
    record = Radio.new({ :name => 'Fun Radio', :permalink => 'funradio'}.merge(options))
    record.save
    record
  end
end
