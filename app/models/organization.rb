class Organization < ApplicationRecord
  validates :username, :password, :subdomain, presence: true 
end
