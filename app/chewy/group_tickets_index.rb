class GroupTicketsIndex < Chewy::Index
  define_type GroupTicket do
    field :group_id
    field :user, value: ->(ticket) { ticket.user.name }
    field :assignee, value: ->(ticket) { ticket.assignee&.name }
    field :messages, value: ->(ticket) { ticket.messages.map(&:content) }
    field :status
  end
end
