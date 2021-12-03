class UserIpAddress < ApplicationRecord
  belongs_to :user, required: true

  validates :ip_address, presence: true
end
