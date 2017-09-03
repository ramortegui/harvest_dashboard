require 'harvest/api_client'
module Harvest
  class Report
    def initialize(organizations, from, to)
      @organizations = organizations
      @from = from
      @to = to
      @report = []
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
  end
end
