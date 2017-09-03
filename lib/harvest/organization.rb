module Harvest
  class Organization
    attr_reader :username, :password, :subdomain
    def initialize(username, password, subdomain)
      @username = username
      @password = password
      @subdomain = subdomain
    end
  end 
end
