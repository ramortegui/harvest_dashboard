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
        report_hash = {}
        #check the connections
        api_client = Harvest::ApiClient.new(org)
        company_info = api_client.who_am_i

        [:clients, :people, :tasks , :projects].pmap{ |resource|
          local_api_client = Harvest::ApiClient.new(org)
          report_hash[resource] = local_api_client.get_resource(resource.to_s)
        }

        entries = []

        report_hash[:projects].pmap{ |proy|
          local_api_client = Harvest::ApiClient.new(org)
          entries += local_api_client.get_resource("projects/#{proy["project"]["id"]}/entries?from=#{@from}&to=#{@to}")
        }

        report_hash[:entries] = entries
        report_hash[:organization] =  company_info["company"]["name"]

        @report << report_hash
      }
      @report
    end

    def get_detailed_report(  )
      report = get_structured_report
      detailed_report = []
      @report.each{ |company_report|
        clients = convert_to_hash(:clients, company_report)
        people = convert_to_hash(:people, company_report)
        tasks = convert_to_hash(:tasks, company_report)
        projects = convert_to_hash(:projects, company_report)

        company_report[:entries].each { |entry|
          day_entry = entry["day_entry"]
          project_id = projects[day_entry["project_id"]]["id"]
          client_id = projects[day_entry["project_id"]]["client_id"]
          hash_entry = {
            "date" => day_entry["spent_at"],
            "project" => projects[project_id]["name"],
            "client" => clients[client_id]["name"],
            "project_active" => projects[day_entry["project_id"]]["active"],
            "task" => tasks[day_entry["task_id"]]["name"],
            "person" => people[day_entry["user_id"]]["first_name"]+" "+
                        people[day_entry["user_id"]]["last_name"],
            "hours" => day_entry["hours"],
            "organization" => company_report[:organization]
          }
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
