module Harvest
  # Object used as an abstraction of the harvestapp account
  class Organization
    attr_reader :username, :password, :subdomain
    #Receive at lease the useranme, password, and the subdomain of the account.
    def initialize(username, password, subdomain)
      @username = username
      @password = password
      @subdomain = subdomain
    end
  end 
end
