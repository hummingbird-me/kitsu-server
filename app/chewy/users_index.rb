class UsersIndex < Chewy::Index
  define_type User do
    def self.blocking(*user_ids)
      filter { _id(:or) != user_ids.flatten }
    end

    def self.active
      filter { deleted_at.nil? }
    end

    field :name
    field :past_names
    field :updated_at
    field :deleted_at
  end

  define_type GroupMember.includes(:user, group: [:category]) do
    def self.blocking(*user_ids)
      filter { user_id(:or) != user_ids.flatten }
    end

    def self.visible_for(user)
      return filter { public_visible == true } unless user
      group_ids = user.group_members.pluck(:group_id)
      filter { (group_id(:or) == group_ids) | (public_visible == true) }
    end

    def self.sfw
      filter { (nsfw == false) & (group_category != 'nsfw') }
    end

    field :group_id
    field :user_id
    field :rank
    field :name, value: ->(mem) { mem.user&.name }
    field :past_names, value: ->(mem) { mem.user&.past_names }
    field :group_name, value: ->(mem) { mem.group&.name }
    field :group_category, value: ->(mem) { mem.group&.category&.slug }
    field :nsfw, value: ->(mem) { mem.group&.nsfw }
    field :public_visible
    field :created_at
  end
end
