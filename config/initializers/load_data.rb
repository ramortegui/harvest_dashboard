Rails.application.config.before_initialize do
  require 'harvest'
  from = (Date.today - 2.years).to_datetime.strftime('%Y%m%d')
  to = Date.today.to_datetime.strftime('%Y%m%d')
  Organization.persist_detailed_report(from,to)      
end
