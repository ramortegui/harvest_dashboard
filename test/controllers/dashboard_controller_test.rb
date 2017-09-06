require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    Organization.delete_all
    Organization.new({
      "username" => 'ruben.amortegui@gmail.com',
      "password" => 'publico01',
      "subdomain" => "ramortegui"
    }).save
  end
  test "should get index" do
    get dashboard_index_url
    assert_response :success
  end

  test 'shold get index' do
    post dashboard_index_url, params: { from: '20160101', to: '20161231' }
    assert_response :success
  end



end
