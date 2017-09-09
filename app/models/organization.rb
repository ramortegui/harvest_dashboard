class Organization < ApplicationRecord
  validates :username, :password, :subdomain, presence: true 
  validates_with OrganizationValidator

  def self.detailed_report(from,to)
    require 'harvest'
    @detailed_report = []
    organizations = Organization.all.map{ |org|
      organization = Harvest::Organization.new(org.username, org.password, org.subdomain)
    }
    if( organizations.count > 0 )
      report = Harvest::Report.new( organizations, from, to)
      @detailed_report = report.get_detailed_report
    end
    @detailed_report
  end
  # Save/Update local db
  def self.persist_detailed_report(from,to)
    organizations = Organization.all
    report = Harvest::Report.new(organizations,from,to) 
    report.persist_detailed_report(report.get_detailed_report)
  end

end
