class GroupTicketResource < BaseResource
  attributes :status, :created_at

  has_one :user
  has_one :group
  has_one :assignee
  has_many :messages
end
