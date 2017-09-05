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


  test "Organization is not valid with if can't do a connection" do
    organization = Organization.new({ "username" => 'ruben.amortegui@gmail.com',
                                      "password" => 'publico02',
                                      "subdomain" => 'ramortegui'})
    assert_not organization.valid?, 'Organization is not valid because wrong credentials'
    assert_equal ["There is an issue with the harvest account, please check credentials."], organization.errors.messages[:base],"Error message when having issues with credentials."
  end

end
