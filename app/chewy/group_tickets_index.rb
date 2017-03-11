class GroupTicketsIndex < Chewy::Index
  define_type GroupTicket do
    def self.visible_for(user)
      return filter { _id == false } unless user
      members = GroupMember.with_permission(:tickets).for_user(user)
      groups = members.pluck(:group_id)
      filter { (group_id(:or) == groups) | (user_id == user.id) }
    end

    field :group_id
    field :user_id
    field :user, value: ->(ticket) { ticket.user.name }
    field :assignee, value: ->(ticket) { ticket.assignee&.name }
    field :messages, value: ->(ticket) { ticket.messages.map(&:content) }
    field :status
    field :created_at
  end
end
