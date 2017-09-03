require 'test_helper'
require 'harvest/organization'

class HarvestOrganizationTest < ActiveSupport::TestCase
  @username = 'username'
  @password = 'password'
  setup do
    @organization = Harvest::Organization.new(@username, @passsword)
  end

  test "Create a new Organization" do
    assert_equal(Harvest::Organization, @organization.class, "Create a new organization")
  end

  test "Organization needs to have a email and password" do
    assert(Harvest::Organization.new(@username, @password),
           "New organization with minimum params")
  end

end

