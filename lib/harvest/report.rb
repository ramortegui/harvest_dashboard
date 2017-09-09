require 'harvest'
require 'date'
module Harvest
  # This class is used to create the reports based on an array of
  # Harvest::Organization and two dates (from, to)
  class Report
    attr_reader :error
    # Initialize the report, and update the forma of dates in case of erros
    # As default: no report records, and no errors
    def initialize(organizations, from, to)
      @organizations = organizations
      check_date_format(from)
      check_date_format(to)
      check_date_range(from,to)
      @from = from
      @to = to
      @report = []
      @error = nil
    end

    # For each organization we need to call the information of the account,
    # clients, people, tasks, and projects, then we get the detailed entries
    # and complete each record with the corresponding information.
    def get_structured_report

      # Loop organization
      @organizations.each { |org|
        report_hash = {}

        # Add to the report_hash information about each resource 
        # Celluloid pmap will help us sending requests in parallel

        api_client = Harvest::ApiClient.new(org)
        [:"account/who_am_i", :clients, :people, :tasks , :projects].each{ |resource|
          report_hash[resource] = api_client.get_resource(resource.to_s)
        }
        api_client = nil

        # Initialize an array of entries
        entries = []

        # Load entries for each project
        # Celluloid pmap will help us sending requests in parallel
        api_client = Harvest::ApiClient.new(org)
        report_hash[:projects].each { |proy|
          entries += api_client.get_resource("projects/#{proy["project"]["id"]}/entries?from=#{@from}&to=#{@to}")
        }
        api_client = nil
      
        # Add entries
        report_hash[:entries] = entries

        # Add name of the organization
        report_hash[:organization] =  report_hash[:"account/who_am_i"]["company"]["name"]

        # Add to the report array information about each organization
        @report << report_hash
      }
      @report
    end

    # The detailed report is going to take the information of get_structured_report
    # and will create the associations and the final array with information complete
    # of each time record 
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
            "id" => day_entry["id"],
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

    def persist_detailed_report(detailed_report)
      detailed_report.map{ |org|
        begin
          Entry.find_or_create_by!(org)
        rescue
          entry = Entry.find_by_id(org["id"])
          org.delete("id")
          entry.update(org)
        end
      }
    end

private
    
    # Check valid date formats, in case of erro is going to raise and error 
    def check_date_format(date)
      begin
        Date.strptime(date, '%Y%m%d')
      rescue
        @error = "Invalid date."
        raise @error
      end
    end

    def check_date_range(from,to)
       if ( Date.strptime(to, '%Y%m%d') < Date.strptime(from, '%Y%m%d') )
         @error = "Invalid date range."
         raise @error
       end
    end

    #Get a structure, and return a hash based on their id.
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
