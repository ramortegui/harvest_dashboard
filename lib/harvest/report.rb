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

    def get_detailed_report( report = nil )
      report = report || get_structured_report
      detailed_report = []
      @report.each{ |company_report|
        clients = convert_to_hash(:clients, company_report)
        people = convert_to_hash(:people, company_report)
        tasks = convert_to_hash(:tasks, company_report)
        projects = convert_to_hash(:projects, company_report)
        company_report[:entries].each { |entry|
          hash_entry = entry["day_entry"]
          detailed_report << hash_entry
        }
      }
      detailed_report
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

    def convert_to_hash(structure, data)
      new_structure = {}
      case structure
      when :clients
        data[:clients].each { |client|
          new_structure[client["client"]["id"]] = client["client"]
        }
      when :people
        data[:people].each { |person|
          new_structure[person["user"]["id"]] = person["user"]
        }
      when :tasks
        data[:tasks].each { |task|
          new_structure[task["task"]["id"]] = task["task"]
        }
      when :projects
        data[:projects].each { |project|
          new_structure[project["project"]["id"]] = project["project"]
        }
      end
      new_structure
    end
  end
end
