class Organization < ApplicationRecord
  validates :username, :password, :subdomain, presence: true 
  validates_with OrganizationValidator

  def self.detailed_report
    require 'harvest'
    @detailed_report = []
    organizations = Organization.all.map{ |org|
      organization = Harvest::Organization.new(org.username, org.password, org.subdomain)
    }
    if( organizations.count > 0 )
      report = Harvest::Report.new( organizations, '20160101', '20170101')
      @detailed_report = report.get_detailed_report
    end
    @detailed_report
  end
end
