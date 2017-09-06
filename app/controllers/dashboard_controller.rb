class DashboardController < ApplicationController
  def index
    if( params[:from] )
      @from = Date.parse(params[:from]).strftime('%Y%m%d') 
      @from_show = params[:from]
    else
      @from = DateTime.now.to_date.beginning_of_month.strftime('%Y%m%d')
      @from_show = DateTime.now.to_date.beginning_of_month.strftime('%d-%m-%Y')
    end

    if( params[:to] ) 
      @to = Date.parse(params[:to]).strftime('%Y%m%d')
      @to_show = params[:to] 
    else
      @to = DateTime.now.to_date.end_of_month.strftime('%Y%m%d')
      @to_show = DateTime.now.to_date.end_of_month.strftime('%d-%m-%Y')
    end
    @detailed_report = Organization.detailed_report( @from, @to)
  end
end
