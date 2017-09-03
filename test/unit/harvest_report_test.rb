require 'test_helper'
require 'harvest/organization'
require 'harvest/report'

class HarvestReportTest < ActiveSupport::TestCase
  def setup
    @organizations = []
  end

  test "Create a report based on organizations" do
    report = Harvest::Report.new(@organizations)
    assert_equal(Harvest::Report, report.class, "Report class instantiated successfully")
  end
  test "List clients of an organization" do

  end
end
