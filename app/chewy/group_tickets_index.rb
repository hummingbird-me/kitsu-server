class GroupTicketsIndex < Chewy::Index
  index_scope GroupTicket

  def self.visible_for(user)
    return filter(bool: { must_not: { match_all: {} } }) unless user

    members = GroupMember.with_permission(:tickets).for_user(user)
    groups = members.pluck(:group_id)
    filter(bool: {
      should: [
        { terms: { group_id: groups } },
        { term: { user_id: user.id } }
      ],
      minimum_should_match: 1
    })
  end

  field :group_id
  field :user_id
  field :user, type: 'text', value: ->(ticket) { ticket.user.name }
  field :assignee, type: 'text', value: ->(ticket) { ticket.assignee&.name }
  field :messages, type: 'text', value: ->(ticket) { ticket.messages.map(&:content) }
  field :status, type: 'keyword'
  field :created_at
end
