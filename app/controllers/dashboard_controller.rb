class DashboardController < ApplicationController
  def index
    @detailed_report = Organization.detailed_report
  end
end
