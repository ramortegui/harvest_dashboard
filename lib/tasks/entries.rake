namespace :entries do
  desc "Call harvest API"
  task presist: :environment do 
      organizations = Organization.all
      from = ENV['from']
      to = ENV['to']
      from ||= DateTime.now.to_date.beginning_of_month.strftime('%Y%m%d')
      to ||= DateTime.now.to_date.end_of_month.strftime('%Y%m%d')

      puts "Preloading data from: #{from} to:#{to}"
      report = Harvest::Report.new(organizations,from,to) 
      report.persist_detailed_report(report.get_detailed_report)
  end
end
