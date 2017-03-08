class GroupTicketMessageResource < BaseResource
  attributes :kind, :content, :created_at

  has_one :ticket
  has_one :user
end
