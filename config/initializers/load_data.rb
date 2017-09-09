Rails.application.config.before_initialize do
  require 'harvest'
  organizations = Organization.all
  from = (Date.today - 2.years).to_datetime.strftime('%Y%m%d')
  to = Date.today.to_datetime.strftime('%Y%m%d')
  report = Harvest::Report.new(organizations,from,to) 
  report.persist_detailed_report(report.get_detailed_report)
end
