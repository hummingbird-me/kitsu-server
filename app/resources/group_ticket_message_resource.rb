class GroupTicketMessageResource < BaseResource
  attributes :kind, :content, :content_formatted, :created_at

  has_one :ticket
  has_one :user
end
