# Module to communicate with Harvest accounts via API
module Harvest
  class ApiClient

    require 'json'
    require 'base64'
    require 'date'
    require 'net/http'
    require 'net/https'
    require 'time'
    # his class has been based on:
    # https://github.com/harvesthq/harvest_api_samples/blob/master/harvest_api_sample.rb

    #Preferred method of connection
    HAS_SSL = true
    
    # The Harvest::ApiClient receive as paramente a Harvest::Organization object, and 
    # try to stablish a connection
    def initialize(organization )
      @organization = organization
      @preferred_protocols = [HAS_SSL, ! HAS_SSL]
      connect!
    end

    # Add headers to the request (Json by default)
    def headers
      {
        "Accept"        => "application/json",
        "Content-Type"  => "application/json; charset=utf-8",
        "Authorization" => "Basic #{auth_string}",
        "User-Agent"    => 'API client Ruben' 
      }
    end

    # Create the encoded string to send basic authentication to the api
    def auth_string
      Base64.encode64("#{@organization.username}:#{@organization.password}").delete("\r\n")
    end


    #Receive a path to be called.  In case of success returns the hash representation
    def get_resource(resource)
      request = request("/#{resource}", :get)
      if request.body
        return JSON.parse(request.body)
      else
        @errors << "Error getting clients"
        return nil
      end
    end

    private 

    #Method to stablish communicaton with havestpp server
    def connect!
      port = has_ssl ? 443 : 80
      @connection = Net::HTTP.new("#{@organization.subdomain}.harvestapp.com", port)
      @connection.use_ssl     = has_ssl
      @connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    #By default is going to try ssl, (as per sample code)
    def has_ssl
      @preferred_protocols.first
    end 

    #Receive a path, method and body and makes ask send_request to make the 
    #call, when response is received, is checking the class of the response,
    #and raise and error in case of needed.
    def request path, method = :get, body = ""
      response = send_request( path, method, body)
      if response.class < Net::HTTPSuccess
        on_completed_request
        return response
      elsif response.class == Net::HTTPServiceUnavailable
        raise "Got HTTP 503 three times in a row" if retry_counter > 3
        sleep(response['Retry-After'].to_i + 5)
        request(path, method, body)
      elsif response.class == Net::HTTPFound
        @preferred_protocols.shift
        raise "Failed connection using http or https" if @preferred_protocols.empty?
        connect!
        request(path, method, body)
      else
        raise "#{path}: #{response.message} (#{response.code})\n\n#{dump_headers}\n\n#{response.body}\n"
      end
    end

    #Method that sends the request using the connection used when the
    #object was initialized 
    def send_request path, method = :get, body = ''
      case method
      when :get
        @connection.get(path, headers)
      end
    end

    #If the request was good, doens't need to try again
    def on_completed_request
      @retry_counter = 0
    end

    #Add tries in case of conection failure
    def retry_counter
      @retry_counter ||= 0
      @retry_counter += 1
    end
  end
end
