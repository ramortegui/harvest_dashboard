require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all


  # Add more helper methods to be used by all tests here...
  require 'vcr'
  require 'webmock/minitest'

  VCR.configure do |c|
    c.cassette_library_dir = 'test/vcr_cassettes'
    c.hook_into :webmock
    c.ignore_localhost = true

#    c.default_cassette_options = { :serialize_with => :syck }
#    c.default_cassette_options = { :record => :all, :re_record_interval => 259200 } 
    #c.allow_http_connections_when_no_cassette = true
  end
end
