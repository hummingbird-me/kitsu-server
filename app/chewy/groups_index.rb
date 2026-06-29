class GroupsIndex < Chewy::Index
  index_scope Group

  def self.visible_for(user)
    return filter(terms: { privacy: %w[open restricted] }) unless user

    members = user.group_members.pluck(:group_id)
    filter(bool: {
      should: [
        { terms: { _id: members } },
        { terms: { privacy: %w[open restricted] } }
      ],
      minimum_should_match: 1
    })
  end

  def self.sfw
    filter(bool: {
      must: [
        { term: { nsfw: false } },
        { bool: { must_not: { term: { category: 'nsfw' } } } }
      ]
    })
  end

  field :name, type: 'text'
  field :about, type: 'text'
  field :locale, type: 'keyword'
  field :tagline, type: 'text'
  field :privacy, type: 'keyword'
  field :nsfw
  field :last_activity_at
  field :category, type: 'keyword', value: ->(g) { g.category.name }
end
