require 'harvest/api_client'
require 'date'
module Harvest
  class Report
    attr_reader :error
    def initialize(organizations, from, to)
      @organizations = organizations
      check_date_format(from)
      check_date_format(to)
      @from = from
      @to = to
      @report = []
      @error = nil
    end
    def get_structured_report
      @organizations.each { |org|
        api_client = Harvest::ApiClient.new(org)

        clients = api_client.get_resource('clients')
        people = api_client.get_resource('people')
        tasks = api_client.get_resource('tasks')
        projects = api_client.get_resource('projects')

        entries = []
        projects.each { |proy| 
          project_entries = api_client.get_resource("projects/#{proy["project"]["id"]}/entries?from=#{@from}&to=#{@to}")
          entries += project_entries
        }

        @report <<  {
                      clients: clients,
                      people: people,
                      tasks: tasks,
                      projects: projects,
                      entries: entries
                    }
      }
      @report
    end

private
    def check_date_format(date)
      begin
        Date.strptime(date,'%Y%m%d')
      rescue
        @error = "invalid date"
        raise @error
      end
    end

  end
end
