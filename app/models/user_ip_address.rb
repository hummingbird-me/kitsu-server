class UserIpAddress < ApplicationRecord
  belongs_to :user, optional: false

  validates :ip_address, presence: true
end
