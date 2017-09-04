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
    report = Harvest::Report.new([],'20160101','20160101')
    assert_equal(Harvest::Report, report.class, 'Report class instantiated successfully')
  end

  test 'get info about one organization' do
    organizations = [@organization1]
    report = Harvest::Report.new(organizations,'20160101','20170101')
    structured_report = report.get_structured_report
    assert_equal(1,structured_report.first[:clients].count,"Organization #{@organization1} has 1 client")
    assert_equal(4,structured_report.first[:people].count,"Organization #{@organization1} has 4 people")
    assert_equal(3,structured_report.first[:tasks].count,"Organization #{@organization1} has 3 tasks")
    assert_equal(1,structured_report.first[:projects].count,"Organization #{@organization1} has 1 project")
    assert_equal(71,structured_report.first[:entries].count,"Organization #{@organization1} has 72 entries")
  end

  test 'get info about multiple organizations' do
    organizations = [@organization1, @organization2]
    report = Harvest::Report.new(organizations,'20160101','20170101')
    structure_report = report.get_structured_report
    assert_equal(2, structure_report.count, 'Exists two organizations info')
  end

  test 'rails raises exception on report with invalid dates' do
    organizations = [@organization1]
    err = assert_raises RuntimeError do
      report = Harvest::Report.new(organizations,'','')
      report.get_structured_report
    end
    assert_match /invalid date/, err.message
  end
end
