require 'test_helper'
require 'harvest/organization'
require 'harvest/report'

class HarvestReportTest < ActiveSupport::TestCase
  def setup
    @organization1 = Harvest::Organization.new('ruben.amortegui@gmail.com',
                                                'publico01',
                                                'ramortegui')
    @organization2 = Harvest::Organization.new('browser_80@hotmail.com',
                                                'publico01',
                                                'rubenamortegui1')
  end
  test 'Create a report based on organizations' do
    report = Harvest::Report.new([])
    assert_equal(Harvest::Report, report.class, 'Report class instantiated successfully')
  end
  test 'get clients of an organization' do
    organizations = [@organization1]
    report = Harvest::Report.new(organizations)
    assert_equal(1,report.get_clients.count,"Organization #{@organization1} has 1 client")
  end
end
