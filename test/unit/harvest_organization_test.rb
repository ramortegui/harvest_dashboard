require 'test_helper'
require 'harvest/organization'

class HarvestOrganizationTest < ActiveSupport::TestCase
  setup do
    @username = 'username'
    @password = 'password'
    @organization = Harvest::Organization.new(@username, @password)
  end

  test "Create a new Organization" do
    assert_equal(Harvest::Organization, @organization.class, "Create a new organization")
  end

  test "Organization needs to have a email and password" do
    assert(Harvest::Organization.new(@username, @password),
           "New organization with minimum params")
  end

  test "Organization attributes are accesible" do
    assert_equal(@username, @organization.username, "Username is accesible.")
    assert_equal(@password, @organization.password, "Password is accesible.")
  end

end

