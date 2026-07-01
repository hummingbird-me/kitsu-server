class GroupMembersIndex < Chewy::Index
  index_scope GroupMember.includes(:user, group: [:category])

  def self.blocking(*user_ids)
    filter(bool: { must_not: { terms: { user_id: user_ids.flatten } } })
  end

  def self.visible_for(user)
    return filter(term: { public_visible: true }) unless user

    group_ids = user.group_members.pluck(:group_id)
    filter(bool: {
      should: [
        { terms: { group_id: group_ids } },
        { term: { public_visible: true } }
      ],
      minimum_should_match: 1
    })
  end

  def self.sfw
    filter(bool: {
      must: [
        { term: { nsfw: false } },
        { bool: { must_not: { term: { group_category: 'nsfw' } } } }
      ]
    })
  end

  field :group_id
  field :user_id
  field :rank
  field :name, type: 'text', value: ->(mem) { mem.user&.name }
  field :past_names, type: 'text', value: ->(mem) { mem.user&.past_names }
  field :group_name, type: 'text', value: ->(mem) { mem.group&.name }
  field :group_category, type: 'keyword', value: ->(mem) { mem.group&.category&.slug }
  field :nsfw, value: ->(mem) { mem.group&.nsfw }
  field :public_visible
  field :created_at
end
