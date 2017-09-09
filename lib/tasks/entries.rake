namespace :entries do
  desc "Call harvest API"
  task presist: :environment do
      from = DateTime.now.to_date.beginning_of_month.strftime('%Y%m%d')
      to = DateTime.now.to_date.end_of_month.strftime('%Y%m%d')
      Organization.persist_detailed_report(from,to)
  end
end
