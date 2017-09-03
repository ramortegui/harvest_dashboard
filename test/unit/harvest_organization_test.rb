require 'test_helper'
require 'harvest/organization'

class HarvestOrganizationTest < ActiveSupport::TestCase
  setup do
    @organization = Harvest::Organization.new()
  end

  test "Create a new Organization" do
    assert_equal(Harvest::Organization,@organization.class,"Create a new organization")
  end

end

