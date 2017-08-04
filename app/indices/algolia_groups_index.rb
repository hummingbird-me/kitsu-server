class AlgoliaGroupsIndex < BaseIndex
  attributes :name, :about, :locale, :tagline, :privacy, :nsfw
  attribute :last_activity_at, frequency: 2.5

  has_one :category, as: :name
end
