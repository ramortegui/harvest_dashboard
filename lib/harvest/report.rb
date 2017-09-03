require 'harvest/api_client'
module Harvest
  class Report
    def initialize(organizations)
      @organizations = organizations
      @clients = []
    end
    def get_clients
      @organizations.each { |org|
        puts org
        api_client = Harvest::ApiClient.new(org)
        clients = api_client.get_clients()
      } 
    end
  end
end
