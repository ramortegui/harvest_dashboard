require 'test_helper'
require 'harvest/organization'
require 'harvest/api_client'
require 'json'

class HarvestApiClientTest < ActiveSupport::TestCase
  def setup
    @username = 'ruben.amortegui@gmail.com'
    @password = 'publico01'
    @subdomain = 'ramortegui'
    @organization = Harvest::Organization.new(@username, @password, @subdomain) 
  end

  test 'Get connection to the harvestapp' do
    api_client = Harvest::ApiClient.new(@organization)
    who_am_i = api_client.who_am_i
    assert_equal(@username, JSON.parse(who_am_i.body)["user"]["email"] , "Check success who am I.") 
  end

end