class DashboardController < ApplicationController
  def index
    from = params[:from] ? Date.parse(params[:from]).strftime('%Y%m%d') : DateTime.now.to_date.beginning_of_month.strftime('%Y%m%d')
    to = params[:to] ? Date.parse(params[:to]).strftime('%Y%m%d') : DateTime.now.to_date.end_of_month.strftime('%Y%m%d')
    @detailed_report = Organization.detailed_report( from, to)
  end
end
