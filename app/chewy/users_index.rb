class UsersIndex < Chewy::Index
  define_type User do
    def self.blocking(*user_ids)
      filter { _id(:or) != user_ids }
    end
    field :name
    field :past_names
    field :updated_at
  end
  define_type GroupMember.includes(:user, group: [:category]) do
    def self.blocking(*user_ids)
      filter { user_id(:or) != user_ids }
    end
    field :group_id
    field :user_id
    field :rank
    field :name, value: ->(mem) { mem.user&.name }
    field :past_names, value: ->(mem) { mem.user&.past_names }
    field :group_name, value: ->(mem) { mem.group&.name }
    field :group_category, value: ->(mem) { mem.group&.category&.slug }
    field :created_at
  end
end
