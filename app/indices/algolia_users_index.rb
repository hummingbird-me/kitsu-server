class AlgoliaUsersIndex < BaseIndex
  self.index_name = 'users'

  attributes :name, :past_names, :slug, :title, :pro_expires_at
  attribute :followers_count, frequency: 2.5
  attribute :avatar, format: ShrineAttachmentValueFormatter, method: :avatar_attacher
end
