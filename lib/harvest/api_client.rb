module Harvest
  class ApiClient
    require 'json'
    require 'base64'
    require 'date'
    require 'net/http'
    require 'net/https'
    require 'time'
    #This class has been based on:
    # https://github.com/harvesthq/harvest_api_samples/blob/master/harvest_api_sample.rb
    HAS_SSL          = true
    def initialize(organization )
      @organization = organization
      @preferred_protocols = [HAS_SSL, ! HAS_SSL]
      connect!
    end 
    def who_am_i
      request = request('/account/who_am_i', :get)
      if request.body
        return JSON.parse(request.body)
      else
        @errors << "Error getting account info"
        return nil
      end
    end   

    def headers
      {
        "Accept"        => "application/json",
        "Content-Type"  => "application/json; charset=utf-8",
        "Authorization" => "Basic #{auth_string}",
        "User-Agent"    => 'API client Ruben' 
      }
    end

    def auth_string
      Base64.encode64("#{@organization.username}:#{@organization.password}").delete("\r\n")
    end


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

    def connect!
      port = has_ssl ? 443 : 80
      @connection = Net::HTTP.new("#{@organization.subdomain}.harvestapp.com", port)
      @connection.use_ssl     = has_ssl
      @connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    def has_ssl
      @preferred_protocols.first
    end 

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
        dump_headers = response.to_hash.map { |h,v| [h.upcase,v].join(': ') }.join("\n")
        raise "#{path}: #{response.message} (#{response.code})\n\n#{dump_headers}\n\n#{response.body}\n"
      end
    end

    def send_request path, method = :get, body = ''
      case method
      when :get
        @connection.get(path, headers)
      end
    end

    def on_completed_request
      @retry_counter = 0
    end

    def retry_counter
      @retry_counter ||= 0
      @retry_counter += 1
    end
  end
end
