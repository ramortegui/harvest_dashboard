class DashboardController < ApplicationController
  def index
    #Define and translate dates
    if( params[:from] )
      @from = Date.parse(params[:from]).strftime('%Y%m%d') 
      @from_show = params[:from]
    else
      @from = DateTime.now.to_date.beginning_of_month.strftime('%Y%m%d')
      @from_show = DateTime.now.to_date.beginning_of_month.strftime('%Y-%m-%d')
    end

    if( params[:to] ) 
      @to = Date.parse(params[:to]).strftime('%Y%m%d')
      @to_show = params[:to]
    else
      @to = DateTime.now.to_date.end_of_month.strftime('%Y%m%d')
      @to_show = DateTime.now.to_date.end_of_month.strftime('%Y-%m-%d')
    end

    @detailed_report = Entry.where(:date => @from..@to )
    #Check exceptions running detailed report
    #begin
    #  @detailed_report = Organization.detailed_report( @from, @to)
    #rescue Exception => e
    #  @detailed_report = []
    #  flash.now[:error] =  e.message
    #end
  end
end
