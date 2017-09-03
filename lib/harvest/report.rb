require 'harvest/api_client'
module Harvest
  class Report
    def initialize(organizations)
      @organizations = organizations
      @report = []
    end
    def get_structured_report
      @organizations.each { |org|
        api_client = Harvest::ApiClient.new(org)

        clients = api_client.get_resource('clients')
        people = api_client.get_resource('people')
        @report << { clients: clients, people: people }
      }
      @report
    end
  end
end
