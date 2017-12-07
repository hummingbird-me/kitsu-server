class AlgoliaGroupsIndex < BaseIndex
  self.index_name = 'groups'

  attributes :name, :about, :locale, :tagline, :privacy, :nsfw, :slug
  attribute :last_activity_at, frequency: 2.5
  attribute :members_count, frequency: 10
  attribute :avatar, format: AttachmentValueFormatter

  has_one :category, as: :name
end
