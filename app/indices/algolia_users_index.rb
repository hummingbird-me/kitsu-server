class AlgoliaUsersIndex < BaseIndex
  self.index_name = 'users'

  attributes :name, :past_names, :slug
  attribute :followers_count, frequency: 2.5
  attribute :avatar, format: AttachmentValueFormatter
end
