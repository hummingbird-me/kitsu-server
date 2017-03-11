class UsersIndex < Chewy::Index
  class << self
    def blocking(*user_ids)
      filter { _id(:or) != user_ids }
    end
  end
  define_type User do
    field :name
    field :past_names
    field :updated_at
  end
  define_type GroupMember.includes(:user, group: [:category]) do
    field :group_id
    field :rank
    field :name, value: ->(mem) { mem.user.name }
    field :past_names, value: ->(mem) { mem.user.past_names }
    field :group_name, value: ->(mem) { mem.group.name }
    field :group_category, value: ->(mem) { mem.group.category }
    field :created_at
  end
end
