class GroupTicketMessageResource < BaseResource
  attributes :kind, :content

  has_one :ticket
  has_one :user

  filter :ticket
end
