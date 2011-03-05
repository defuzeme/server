require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  test "can save token" do
    u = users :quentin
    assert_difference 'Token.count' do
      create_token :user => u
    end
  end

  test "can save token with machine infos" do
    u = users :quentin
    machine = {:hostname => 'BigBecane', :os => 'Ubuntu 10.10'}
    t = nil
    assert_difference 'Token.count' do
      t = create_token(:user => u, :machine => machine)
    end
    t.reload
    assert_equal t.machine, machine, 'machine field not conserved'
  end

  test "should generate token" do
    u = users :quentin
    t = create_token :user => u
    assert_match /[a-z][0-9]+/i, t.token, "Bad token"
  end

  test "creation should set last_use_at" do
    u = users :quentin
    t = create_token :user => u
    assert_not_nil t.last_use_at, "last_use_at not set"
  end

  test "can't invite without creator" do
    assert_no_difference 'Token.count' do
      create_token
    end
  end

  protected

  def create_token(options = {})
    Token.create(options)
  end
end
