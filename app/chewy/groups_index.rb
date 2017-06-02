class GroupsIndex < Chewy::Index
  define_type Group do
    def self.visible_for(user)
      return filter { privacy(:or) == %w[open restricted] } unless user
      members = user.group_members.pluck(:group_id)
      filter { (_id(:or) == members) | (privacy(:or) == %w[open restricted]) }
    end

    def self.sfw
      filter { (nsfw == false) & (category != 'nsfw') }
    end

    field :name
    field :about
    field :locale
    field :tagline
    field :privacy
    field :nsfw
    field :last_activity_at
    field :category, value: ->(g) { g.category.name }
  end
end
