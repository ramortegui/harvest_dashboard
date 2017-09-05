class OrganizationValidator < ActiveModel::Validator
  require 'harvest'
  require 'json'
  def validate(record)
    api_client = Harvest::ApiClient.new(Harvest::Organization.new( record.username, record.password,record.subdomain ))
    begin
        who_am_i = api_client.who_am_i
    rescue
        record.errors[:base] << "There is an issue with the harvest account, please check credentials."
    end
  end
end
