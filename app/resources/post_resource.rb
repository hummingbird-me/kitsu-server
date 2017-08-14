class PostResource < BaseResource
  caching

  attributes :content, :content_formatted, :comments_count, :post_likes_count,
    :spoiler, :nsfw, :blocked, :deleted_at, :top_level_comments_count,
    :edited_at, :target_interest, :embed, :embed_url

  has_one :user
  has_one :target_user
  has_one :target_group
  has_one :media, polymorphic: true
  has_one :spoiled_unit, polymorphic: true
  has_one :ama, foreign_key: 'original_post_id', foreign_key_on: :related
  has_many :post_likes
  has_many :comments
  has_many :uploads

  def target_interest=(val)
    _model.target_interest = val.underscore.classify
  end

  def target_interest
    _model.target_interest.underscore.dasherize if _model.target_interest
  end
end
