ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'json'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  include AuthenticatedTestHelper
end

class ActionController::TestCase
  # allows to use response.json and response.xml to get the response in hash format
  def response
    @response.body.tap do |wrap|
      def wrap.json; JSON.parse(self); end
      def wrap.xml; Hash.from_xml(self); end
    end
  end
end
