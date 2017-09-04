class DashboardController < ApplicationController
  require 'harvest'
  def index
    organizations = Organization.all.map{ |org|
      organization = Harvest::Organization.new(org.username, org.password, org.subdomain)
    }
    @detailed_report = []
    if( organizations.count > 0 )
      report = Harvest::Report.new( organizations, '20160101', '20170101')
      @detailed_report = report.get_detailed_report
    end
  end
end
