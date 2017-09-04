require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test "Organization is not valid without params" do
    organization = Organization.new()
    refute organization.valid?, 'Organization is not valid without params'
  end

  test "Organization is not valid with username, password, subdomain" do
    organization = Organization.new({ "username" => 'ruben.amortegui@gmail.com',
                                      "password" => 'publico01', 
                                      "subdomain" => 'ramortegui'})
    assert organization.valid?, 'Organization is not valid without params'
  end

end
