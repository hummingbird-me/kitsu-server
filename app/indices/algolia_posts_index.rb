class AlgoliaPostsIndex < BaseIndex
  self.index_name = 'posts'

  attribute :content
  attribute :post_likes_count, frequency: 2.5
  has_one :user, as: :name
  has_one :group, as: :name, via: :target_group
end
